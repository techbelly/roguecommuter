app_path = File.dirname(__FILE__)
$:.unshift(app_path) unless $:.include?(app_path)
require 'env'
require 'app'
run Sinatra::Application
