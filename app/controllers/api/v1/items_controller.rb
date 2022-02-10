class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: ItemSerializer.new(item), status: :created
    else
      render json: JSON.generate({error: 'error'}), status: 400
    end
  end

  def destroy
    render json: ItemSerializer.new(Item.destroy(params[:id]))
  end

  def update
    # Finds all valid merchant id's
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
