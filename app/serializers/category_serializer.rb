class CategorySerializer
  include JSONAPI::Serializer
  attributes :id, :title, :description, :created_at, :updated_at
end