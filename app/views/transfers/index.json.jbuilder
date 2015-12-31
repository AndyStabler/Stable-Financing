json.array!(@transfers) do |transfer|
  json.extract! transfer, :id, :on, :amount, :recurring, :outgoing, :user_id
  json.url transfer_url(transfer, format: :json)
end
