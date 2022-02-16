class MerchantRevenueSerializer
  include JSONAPI::Serializer

  attribute :revenue do |object|
    object.total_revenue
  end
end
