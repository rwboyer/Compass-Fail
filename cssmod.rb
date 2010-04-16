#Rack version of the testbed

%w( rubygems haml compass sinatra/base rest_client hpricot ).each {|f| require f}

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
		#
		get "/stylesheets/screen.css" do
			puts Compass.sass_engine_options.inspect

			content_type 'text/css'
			sass :"stylesheets/screen", Compass.sass_engine_options
		end

		get "/" do
			haml :content_part, :layout=>:layout
		end

		get "/form" do
			haml :form
		end

		post "/form" do
			s = params[:sometext]
			puts s
			redirect s
		end

		get "/dorss" do
			resp = RestClient.get 'http://photo.rwboyer.com/feed/'
			doc, @posts = Hpricot.XML(resp.to_s), [] 
			(doc/:description).each do |p|
				content = p.inner_html.gsub!(/\<\!\[CDATA\[(.*)\]\]\>/m, '\1')
				@posts << content
			end
			haml :rsspage
		end

	end

end
