task default: %w{server}

desc "start server"
task :server do
  system "shotgun --server=thin --port=3000 config.ru"
end