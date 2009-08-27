require 'sinatra'

require File.join(File.dirname(__FILE__), 'cssmod.rb')

disable :run

set :environment, :development

map "/" do
	CSSmod::TinyApp.run! :host => 'localhost', :port => 9090
end
