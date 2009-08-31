require 'sinatra'

require File.join(File.dirname(__FILE__), 'cssmod.rb')

disable :run

map "/tiny" do
	map "/" do
		run CSSmod::TinyApp
	end
end
