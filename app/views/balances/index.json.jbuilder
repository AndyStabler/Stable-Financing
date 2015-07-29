json.array!(@balances) do |balance|
  json.extract! balance, :id, :value, :transfer_id
  json.url balance_url(balance, format: :json)
end
