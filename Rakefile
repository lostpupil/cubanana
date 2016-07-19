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

