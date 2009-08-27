%w( rubygems sinatra compass ).each {|f| require f}

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
	sass :"stylesheets/screen", :sass => Compass.sass_engine_options
end

get "/" do
	haml :index
end

