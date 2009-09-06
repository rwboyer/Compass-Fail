%w( rubygems sinatra compass rest_client hpricot json sinatra-authentication).each {|f| require f}

use Rack::Session::Cookie, :secret => 'WTF'

set :rpxapikey, '45ba29026c158111481c53d20dd27fead98130f1'
set :rpxappname, 'compassfail'
set :rpxserver, '192.168.1.101:4567'
set :rpxadmins, { 'rwboyer.aperture' => 'admin' }

#Setup sinatra to use Compass with the correct directorys
configure do
	Compass.configuration do |conf|
		conf.project_path = File.dirname(__FILE__)
		conf.sass_dir = File.join('views', 'stylesheets')
	end
end

#Viola a dynamically rendered sass stylesheet using compass mixins
#	from blueprint
#	amazing
get "/stylesheets/screen.css" do
	content_type 'text/css'
	sass :"stylesheets/screen", Compass.sass_engine_options
end

get "/form" do
	login_required('/fail')
	haml :form
end

post "/form" do
	s = params[:sometext]
	puts s
	redirect s
end

get "/dorss" do
	priv_required('admin', '/fail')
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

get "/fail" do
	"Authorization Failure"
end

get "/" do
	haml :content_part
end

