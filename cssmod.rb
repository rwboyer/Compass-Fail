#Rack version of the testbed

%w( rubygems haml compass sinatra/base ).each {|f| require f}

module CSSmod

	class TinyApp < Sinatra::Base

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
		#get "/stylesheets/screen.css" do
		get "/stylesheets/screen.css" do
			puts Compass.sass_engine_options.inspect

			content_type 'text/css'
			sass :"stylesheets/screen", Compass.sass_engine_options
		end

		get "/" do
			haml :index, :layout=>:layout
		end

	end

end
