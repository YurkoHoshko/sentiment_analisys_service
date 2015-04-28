$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'bundler/setup'
require "sinatra/reloader" if ENV['RACK_ENV'] == 'development'
require "sinatra/asset_pipeline"

# Environment setup
environment = ENV['RACK_ENV'].to_sym
Bundler.require :default, ENV['RACK_ENV']

# Twitter Setup
TWITTER_CONFIG = YAML.load_file(File.join(File.dirname(__FILE__), "twitter_secrets.yml")).symbolize_keys

# DB Setup 
db_config = YAML.load_file(File.join(File.dirname(__FILE__), "..", "db", "database.yml"))[ENV["RACK_ENV"]]
Jdbc::Postgres.load_driver
# DB = Sequel.connect(
#   "jdbc:postgresql://localhost/#{db_config['name']}",
#   :user => db_config['user'].to_s,
#   :password => db_config['password'].to_s
# )
# Sequel::Model.db = DB


# General Setup
Dir[File.expand_path('../../app/*/*.rb', __FILE__)].sort.each { |f| require f }
Dir[File.expand_path('../../app/**.rb', __FILE__)].each { |f| require f }
Dir[File.expand_path('../../app/lib/*/*.rb', __FILE__)].sort.each { |f| require f }
Dir[File.expand_path('../../app/lib/**.rb', __FILE__)].each { |f| require f }
Dir[File.expand_path('../../app/models/**.rb', __FILE__)].each { |f| require f }
Dir[File.expand_path('../../app/services/*/*.rb', __FILE__)].each { |f| require f }
Dir[File.expand_path('../../app/services/**.rb', __FILE__)].each { |f| require f }
Dir[File.expand_path('../../app/web/base.rb', __FILE__)].each { |f| require f }
Dir[File.expand_path('../../app/web/**.rb', __FILE__)].each { |f| require f }

# Actor Registry Setup
Celluloid::Actor[:polling_handler] = Services::PollingHandler.new
Celluloid::Actor[:polling_agent] = Services::PollingAgent.pool(:size => 10)
# Celluloid::Actor[:sentence_persistence_handler] = Services::SentencePersistanceHandler.pool(:size => 10)



# logger.info "#{APPNAME} ready on port: #{$rport}, env: #{ENV['RACK_ENV']}"
