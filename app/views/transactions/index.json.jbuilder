json.array!(@transactions) do |transaction|
  json.extract! transaction, :id, :dat, :amount, :recurring, :daily, :weekly, :monthly
  json.url transaction_url(transaction, format: :json)
end
