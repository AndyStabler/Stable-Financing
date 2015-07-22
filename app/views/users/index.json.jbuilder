json.array!(@users) do |user|
  json.extract! user, :id, :name, :balance
  json.url user_url(user, format: :json)
end
