require "cuba/test"
require "./app"

scope do
  test "Bootstrap" do
    get "/api/v1"
    resp = {data:'hello world'}.to_json
    assert resp == last_response.body
  end
end
