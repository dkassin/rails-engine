class ItemsSoldSerializer
  include JSONAPI::Serializer
  attributes :name

  attribute :count do |object|
    object.total_items_sold
  end
end
