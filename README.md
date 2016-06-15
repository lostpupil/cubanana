#cubaka

## Description

This is a api framework based on cuba and sequel, it's a very simple framework with several gems inside. Tiny, but functional.

## Define a model

Create a new file in `app/model` named 'dummy.rb' like below

```ruby
class Dummy < Sequel::Model
end
```

## Define an api

create a new file in `app/api` named 'v1.rb' like below

```ruby
V1.define do
  on get do
    on root do
      as_json do
        {data: 'hello world'}
      end
    end
  end
  on post do
  end
```

## Define a plugin

create a new file in `app/plugin` named 'as.rb' like below

```ruby
module Cuba::Sugar
  module As
    # Public: Sugar to do some common response tasks
    #
    # http_code     - Response status code (default: 200)
    # extra_headers - Extra headers hash (default: {})
    #
    # Examples:
    #
    #   on post, "users" do
    #     as 201 do
    #       "User successfully created!"
    #     end
    #   end
    def as(http_code = 200, extra_headers = {}, &block)
      res.status = http_code
      res.headers.merge! extra_headers
      res.write yield if block
    end

    # Public: Sugar to do some common response tasks as_json
    #
    # http_code     - Response status code (default: 200)
    # extra_headers - Extra headers hash (default: {})
    # Examples:
    #
    #   on post, "users" do
    #     as_json 201 do
    #       "User successfully created!"
    #     end
    #   end
    def as_json(http_code = 200, extra_headers = {}, &block)
      require 'json'
      extra_headers["Content-Type"] ||= "application/json"
      as(http_code, extra_headers) { yield.to_json if block }
    end
  end
end

```

## Task

You will have 2 rake task called server and console, you can run a server by `rake server` or just `rake`, also, you can run a console which load all the models by `rake console`