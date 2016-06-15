class V1 < Cuba; end
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
end
