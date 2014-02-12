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

    # get an HTML representation of the form
    # e.g., /form.html?pdf=http://help.adobe.com/en_US/Acrobat/9.0/Samples/interactiveform_enabled.pdf
    get '/form' do
      liquid :form, :locals => { :pdf => params['pdf'], :fields => PdfFiller::Filler.new.get_fields( params['pdf'] ) }, :layout => :bootstrap
    end

    helpers do
     # Construct a link to +url_fragment+, which should be given relative to
     # the base of this Sinatra app.  The mode should be either
     # <code>:path_only</code>, which will generate an absolute path within
     # the current domain (the default), or <code>:full_url</code>, which will
     # include the site name and port number.  The latter is typically necessary
     # for links in RSS feeds.  Example usage:
     #
     #   link_to "/foo" # Returns "http://example.com/myapp/foo"
     #
     #--
     # Thanks to cypher23 on #mephisto and the folks on #rack for pointing me
     # in the right direction.
     def link_to url_fragment, mode=:path_only
       case mode
       when :path_only
         base = request.script_name
       when :full_url
         if (request.scheme == 'http' && request.port == 80 ||
             request.scheme == 'https' && request.port == 443)
           port = ""
         else
           port = ":#{request.port}"
         end
         base = "#{request.scheme}://#{request.host}#{port}#{request.script_name}"
       else
         raise "Unknown script_url mode #{mode}"
       end
       "#{base}#{url_fragment}"
     end
   end
  end
end
