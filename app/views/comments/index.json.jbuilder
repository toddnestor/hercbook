json.array!(@comments) do |comment|
  json.extract! comment, :id, :type, :content
  json.url comment_url(comment, format: :json)
end
