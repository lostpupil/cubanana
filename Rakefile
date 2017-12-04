task default: %w{server}

desc "start server"
task :server do
  exec "shotgun --server=thin --port=3000 config.ru"
end

desc "start console"
task :console do
  require 'pry'
  require './app'
  Pry.start
end

task :test do
  exec "cutest test/*.rb"
end

namespace :db do
  require 'yaml'
  require 'sequel'
  Sequel.extension :migration, :core_extensions

  dc = YAML.load_file('./config/database.yml')

  if ENV['RACK_ENV'] == 'production'
    DBM = Sequel.connect(dc['production'])
  else
    DBM = Sequel.connect(dc['development'])
  end

  desc "Generate Schema"
  task :schema do
    require './app'
    File.open("db/schema.txt", "w") do |writeable|
      Dir.glob("app/model/*").each.with_index do |file, idx|
        model_name = file.split("\/").last.split('.').first
        if model_name.include?("_")
          model_name = model_name.split("_").map(&:capitalize).join
        else
          model_name = model_name.capitalize
        end
        writeable << model_name + "\n"
        writeable << "==================================================\n"
        Object.const_get(model_name).db_schema.each do |k,v|
          writeable << "#{k.to_s.ljust(20, ' ')}#{v[:db_type].to_s.rjust(30, ' ')}\n"
        end
        if Dir.glob("app/model/*").count == idx + 1
          writeable << "--------------------------------------------------"
        else
           writeable << "--------------------------------------------------\n\n"
        end
      end
    end
  end

  desc "Prints current schema version"
  task :version do
    version = if DBM.tables.include?(:schema_info)
      DBM[:schema_info].first[:version]
    end || 0

    puts "Schema Version: #{version}"
  end

  desc "Perform migration up to latest migration available"
  task :migrate do
    Sequel::Migrator.run(DBM, "db/migrations")
    Rake::Task['db:version'].execute
    Rake::Task['db:schema'].execute
  end

  desc "Perform rollback to specified target or full rollback as default"
  task :rollback, :target do |t, args|
    args.with_defaults(:target => 0)

    Sequel::Migrator.run(DBM, "db/migrations", :target => args[:target].to_i)
    Rake::Task['db:version'].execute
  end

  desc "Perform migration reset (full rollback and migration)"
  task :reset do
    Sequel::Migrator.run(DBM, "db/migrations", :target => 0)
    Sequel::Migrator.run(DBM, "db/migrations")
    Rake::Task['db:version'].execute
  end

  desc "Generate some seed data"
  task :seeds do
    require './app'
    require './db/seeds'
  end

  desc "Generate migration"
  task :generate, :source do |t, args|
    name = args[:source]
    f_count = Dir.glob("./db/migrations/*").count

    version = if DBM.tables.include?(:schema_info)
      DBM[:schema_info].first[:version]
    end || 0
    tpl = <<-TPL
Sequel.migration do
  change do
  end
end
    TPL
    if f_count == version
      f_name = "#{version + 1}_#{name}.rb"
      File.open("./db/migrations/#{f_name}", "w") do |f|
        f.write tpl
      end
    else
      puts "Invalid file count in migrations."
    end
  end
end
