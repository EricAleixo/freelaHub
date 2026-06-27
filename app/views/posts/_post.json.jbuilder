json.extract! post, :id, :title, :description, :post_owner_id, :created_at, :updated_at
json.url post_url(post, format: :json)
