$:.unshift File.dirname($0)

require 'fox16'
include Fox

require 'nokogiri'
require 'open-uri'
require 'includes/gui'
require 'includes/xml'
require 'includes/prepare'

if __FILE__ == $0
	FXApp.new("Plauschangriff Downloader", "FXRuby") do |app|
		Gui.new(app)
		app.create
		app.run
	end
end