Cuba.use Rack::Cors do
  allow do
    origins '*'
    resource '/*', :headers => :any, :methods => [:get,:post,:delete,:put]
  end
end

Cuba.define do
  on "api/v1" do
    run V1
  end
end