class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    render json: ItemSerializer.new(Item.create(item_params)), status: :created
  end

  def destroy
    render json: ItemSerializer.new(Item.destroy(params[:id]))
  end

  def update
    merchant_id = Merchant.all.map do |merchant|
                    merchant.id
                  end
    if item_params[:merchant_id] != nil
      if merchant_id.include?(item_params[:merchant_id])
        render json: ItemSerializer.new(Item.update(params[:id], item_params))
      else
        render status: 404
      end
    else
      render json: ItemSerializer.new(Item.update(params[:id], item_params))
    end
  end

private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
