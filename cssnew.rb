%w( rubygems sinatra compass rest_client hpricot json ).each {|f| require f}

use Rack::Session::Cookie, :secret => 'WTF'

#Setup sinatra to use Compass with the correct directorys
configure do
	Compass.configuration do |conf|
		conf.project_path = File.dirname(__FILE__)
		conf.sass_dir = File.join('views', 'stylesheets')
	end
end

def authenticate(token)
	response = JSON.parse(RestClient.post 'https://rpxnow.com/api/v2/auth_info', :token => token, 'apiKey' => '45ba29026c158111481c53d20dd27fead98130f1', :format => 'json', :extended => 'false')
	puts response.inspect
	return response if response['stat'] == 'ok'
	return nil
end

def auth_required
	if session[:user]
		return true
	else
		session[:return_to] = request.fullpath
		redirect '/'
		return false
	end
end

#Viola a dynamically rendered sass stylesheet using compass mixins
#	from blueprint
#	amazing
get "/stylesheets/screen.css" do
	content_type 'text/css'
	sass :"stylesheets/screen", Compass.sass_engine_options
end

#bogus - this is not how rpx open-id works
get "/login" do
	'You are logged in!' if authenticate(params[:token])
end

#this is actually what you need
post "/login" do
	r = nil
	session[:user] = r
	session[:user] = r if r = authenticate(params[:token])
	puts r.inspect
	puts session[:user].inspect
	redirect '/'
end

get "/form" do
	auth_required
	haml :form
end

post "/form" do
	s = params[:sometext]
	puts s
	redirect s
end

get "/dorss" do
	auth_required
	resp = RestClient.get 'http://photo.rwboyer.com/feed/'
	doc, @posts = Hpricot::XML(resp), [] 
	puts doc.inspect
	(doc/:description).each do |p|
		#content = p.inner_html.gsub!(/\<\!\[CDATA\[(.*)\]\]\>/m, '\1')
		content = p.inner_html
		@posts << content
	end
	puts @posts.inspect
	haml :rsspage
end

get "/" do
	haml :content_part
end

