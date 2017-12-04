require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, ENV["RACK_ENV"] || 'development')

DATABASE_CONFIG = YAML.load_file('./config/database.yml')
NORAML_CONFIG = YAML.load_file('./config/enviroments.yml')

Qiniu.establish_connection! :access_key => NORAML_CONFIG["qiniu"]["ak"], :secret_key => NORAML_CONFIG["qiniu"]["sk"]

if ENV['RACK_ENV'] == 'production'
  DB = Sequel.connect(DATABASE_CONFIG['production'])
else
  DB = Sequel.connect(DATABASE_CONFIG['development'])
end

# ap DB.drop_schema()
Sequel::Model.plugin :timestamps, create: :created_at, update: :updated_at

Dir["./app/plugin/*.rb"].each { |file| require file }
Cuba.plugin Cuba::Sugar::As
Cuba.plugin Cuba::Sugar::TypedParams

Dir["./app/api/*.rb"].each { |file| require file }

Dir["./app/model/*.rb"].each { |file| require file }