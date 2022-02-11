class Api::V1::SearchesController < ApplicationController
  def find
    if params[:name].present? & !params[:min_price].present? & !params[:max_price].present?
      item = Item.where("name ILIKE ?", "%#{params[:name]}%").order(name: :asc).first
        if item.nil?
          render json: { data: { message: "Item not found"}}
        else
          render json: ItemSerializer.new(item)
        end
    elsif params[:min_price].present? & !params[:name].present?
      if params[:min_price].to_i > 0
        item = Item.where("unit_price >= ?", "#{params[:min_price]}").order(name: :asc).first
          if item.nil?
            render json: JSON.generate( { data: {error: 'error'}}), status: 400
          else
            render json: ItemSerializer.new(item)
          end
      else
         render json: JSON.generate({error: 'error'}), status: 400
      end
    elsif params[:max_price].present? && !params[:name].present?
      if params[:max_price].to_i > 0
        item = Item.where("unit_price <= ?", "#{params[:max_price]}").order(name: :asc).first
        if item.nil?
          render json: { data: { message: "Item not found"}}
        else
          render json: ItemSerializer.new(item)
        end
      else
        render json: JSON.generate({error: 'error'}), status: 400
     end
    elsif params[:min_price].present? & params[:max].present? & !params[:name].present?
      if params[:max_price].to_i > 0 & params[:min_price].to_i > 0
        item = Item.where("unit_price >= ?", "#{params[:min_price]}").where("unit_price <= ?", "#{params[:max_price]}").order(name: :asc).first
        if item.nil?
          render json: { data: { message: "Item not found"}}
        else
          render json: ItemSerializer.new(item)
        end
      else
        render json: JSON.generate({error: 'error'}), status: 400
      end
    else
      render json: JSON.generate({error: 'error'}), status: 400
    end
  end

  def find_all
    merchants = Merchant.where("name ILIKE ?", "%#{params[:name]}%")
    if merchants.nil?
      render json: { data: { message: "Merchant not found"}}
    else
      render json: MerchantSerializer.new(merchants)
    end
  end
end
