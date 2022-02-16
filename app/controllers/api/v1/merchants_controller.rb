class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end

  def most_items
    if params[:quantity].nil?
      render json: JSON.generate({error: 'error'}), status: 400
    else
      number = params[:quantity]
      merchant = Merchant.top_merchants_by_item_sold(number)
      render json: ::ItemsSoldSerializer.new(merchant)
    end
  end
end
