# app.rb
require 'rubygems'
require 'sinatra'
require 'thin'
require 'open-uri'
require 'markdown'
require 'liquid'

module PdfFiller
  class App < Sinatra::Base
    set :root, File.dirname(__FILE__)
    set :views, File.dirname(__FILE__) + "/views"

    # documentation
    get '/' do 
      markdown :index, :layout => :bootstrap, :layout_engine => :liquid
    end

    # return a filled PDF as a result of post data
    post '/fill' do
      send_file PdfFiller::Filler.new.fill( params['pdf'], params ).path, :type => "application/pdf", :filename => File.basename( params['pdf'] ), :disposition => :inline
    end

    # get an HTML listing of all the fields
    # e.g., /fields.html?pdf=http://help.adobe.com/en_US/Acrobat/9.0/Samples/interactiveform_enabled.pdf
    get '/fields' do
      liquid :fields, :locals => { :pdf => params['pdf'], :fields => PdfFiller::Filler.new.get_fields( params['pdf'] ) }, :layout => :bootstrap
    end

    # return JSON list of field names
    # e.g., /fields.json?pdf=http://help.adobe.com/en_US/Acrobat/9.0/Samples/interactiveform_enabled.pdf
    get '/fields.json' do
      PdfFiller::Filler.new.get_fields( params['pdf'] ).to_json
    end
  end
end
