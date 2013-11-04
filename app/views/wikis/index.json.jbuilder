json.array!(@wikis) do |wiki|
  json.extract! wiki, :title, :page_id
  json.url wiki_url(wiki, format: :json)
end
