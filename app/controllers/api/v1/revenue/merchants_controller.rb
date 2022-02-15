class Api::V1::Revenue::MerchantsController < ApplicationController
  def index
    if params[:quantity].nil?
      render json: JSON.generate({error: 'error'}), status: 400
    else
      number = params[:quantity]
      merchant = Merchant.top_merchants_by_revenue(number)
      render json: ::MerchantNameRevenueSerializer.new(merchant)
    end
  end
end
