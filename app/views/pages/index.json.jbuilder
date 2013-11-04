json.array!(@pages) do |page|
  json.extract! page, :title
  json.url page_url(page, format: :json)
end
