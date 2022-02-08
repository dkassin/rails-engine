require 'rails_helper'

describe "Items API" do
  it "sends a list of Items" do

    create_list(:item, 5)

    get '/api/v1/items'

    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(items[:data].count).to eq(5)

    items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item[:id].to_i).to be_an(Integer)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_a(Integer)
    end
  end

  it 'can get one item by its id' do
    id = create(:item).id

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_successful

    expect(item[:data]).to have_key(:id)
    expect(item[:data][:id].to_i).to be_an(Integer)

    expect(item[:data][:attributes]).to have_key(:name)
    expect(item[:data][:attributes][:name]).to be_a(String)

    expect(item[:data][:attributes]).to have_key(:description)
    expect(item[:data][:attributes][:description]).to be_a(String)

    expect(item[:data][:attributes]).to have_key(:unit_price)
    expect(item[:data][:attributes][:unit_price]).to be_a(Float)

    expect(item[:data][:attributes]).to have_key(:merchant_id)
    expect(item[:data][:attributes][:merchant_id]).to be_a(Integer)

  end

  it "can create a new item"  do
    merchant = create(:merchant)
    item_params = ({
                    name: 'Cartman Figurine',
                    description: 'A statue of the coon',
                    unit_price: 314.12,
                    merchant_id: merchant.id
                  })
    headers = {"CONTENT_TYPE" => "application/json"}


    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last

    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
  end

  it "can destroy an item item"  do
    merchant = create(:merchant)
    item_params = ({
                    name: 'Cartman Figurine',
                    description: 'A statue of the coon',
                    unit_price: 314.12,
                    merchant_id: merchant.id
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

    created_item = Item.last
    expect(Item.all.count).to eq(1)

    delete "/api/v1/items/#{created_item.id}"

    expect(response).to be_successful
    expect(Item.all.count).to eq(0)
    expect{Item.find(created_item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end
end
