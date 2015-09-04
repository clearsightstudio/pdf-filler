# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "pdf_filler/version"

Gem::Specification.new do |s|
  s.name = "pdf_filler"
  s.version = PdfFiller::VERSION
  s.authors = ["Daniel Berkompas", "GSA"]
  s.email = "support@clearsightstudio.com"
  s.summary = "A wrapper around GSA's pdf-filler service as a gem."
  
  s.files = Dir.glob("{bin,lib}/**/*")
  
  s.add_dependency 'rake'
  s.add_dependency 'sinatra'
  s.add_dependency 'thin'
  s.add_dependency 'liquid'
  s.add_dependency 'pdf-forms', '~> 0.6.0'
  s.add_dependency 'prawn'
  s.add_dependency 'markdown'
end
