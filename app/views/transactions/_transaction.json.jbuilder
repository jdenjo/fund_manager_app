json.extract! transaction, :id, :shares, :price, :status, :reason, :position_id, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
