ENV["SINATRA_ENV"] ||= 'development'

require 'bundler'
Bundler.require(:default, ENV["SINATRA_ENV"])
require 'sinatra/activerecord'
require 'rack-flash'
require 'sidekiq'
require 'sidekiq/web'
require 'sidekiq'
require 'sendgrid-ruby'
require 'net/http'
require 'uri'

include SendGrid

Sidekiq.configure_client do |config|
  config.redis = { :host => "127.0.0.1", :port => 6379, :db => 15, :password => 12345 }
end

Sidekiq.configure_server do |config|
  config.redis = { :host => "127.0.0.1", :port => 6379, :db => 15, :password => 12345 }
end

connection_details = YAML::load(File.open('config/database.yml'))[ENV["SINATRA_ENV"]]
ActiveRecord::Base.establish_connection(connection_details)

require_all 'app'
