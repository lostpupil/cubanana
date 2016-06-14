require 'sequel'
require 'awesome_print'
require 'yaml'

require 'cuba'
require 'rack/cors'
require 'rack/protection'

DATABASE_CONFIG = YAML.load_file('./config/database.yml')

if ENV['ST_ENV'] == 'production'
  DB = Sequel.postgres(DATABASE_CONFIG['production'])
else
  DB = Sequel.postgres(DATABASE_CONFIG['development'])
end

DB.extension :pg_array
DB.extension :pg_hstore
DB.extension :pg_json
# ap DB.drop_schema()
Sequel::Model.plugin :timestamps

Dir["./app/plugin/*.rb"].each { |file| require file }
Cuba.plugin Cuba::Sugar::As
Dir["./app/api/*.rb"].each { |file| require file }

Dir["./app/model/*.rb"].each { |file| require file }