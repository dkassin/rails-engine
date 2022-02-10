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

  it "can update an existing item" do
    id = create(:item).id
    previous_name = Item.last.name
    item_params = { name: "Kaw's statue" }
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
    item = Item.find_by(id: id)

    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq("Kaw's statue")
  end

  it "errors if trying to update with a non-existent merchant id" do
    merchants = create_list(:merchant, 3)
    id = create(:item).id
    previous_merchant_id = Item.last.merchant_id
    item_params = { merchant_id: 1324657 }
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
    item = Item.find_by(id: id)

    expect(response).to_not be_successful
    expect(item.name).to_not eq(previous_merchant_id)
    expect(item.merchant_id).to_not eq(1324657)
  end

  it "sends a list of Items for a given merchant" do
    merchants = create_list(:merchant, 2)
    merchant = merchants.first
    items = create_list(:item, 5, merchant: merchant)


    get "/api/v1/merchants/#{merchant.id}/items"

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

  it 'find a single item which matches a name search term' do
    o_items = create_list(:item, 300)

    get "/api/v1/items/find?name=shirt"

    item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(item[:data]).to have_key(:id)
    expect(item[:data][:id].to_i).to be_an(Integer)

    expect(item[:data]).to have_key(:type)
    expect(item[:data][:type]).to be_an(String)

    expect(item[:data][:attributes]).to have_key(:name)
    expect(item[:data][:attributes][:name]).to be_a(String)

    expect(item[:data][:attributes]).to have_key(:description)
    expect(item[:data][:attributes][:description]).to be_a(String)

    expect(item[:data][:attributes]).to have_key(:unit_price)
    expect(item[:data][:attributes][:unit_price]).to be_a(Float)

    expect(item[:data][:attributes]).to have_key(:merchant_id)
    expect(item[:data][:attributes][:merchant_id]).to be_a(Integer)
  end

  it 'sad path when search name provides no items ' do
    o_items = create_list(:item, 300)

    get "/api/v1/items/find?name=hellomynameis"

    item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(item[:data]).to have_key(:message)
    expect(item[:data][:message]).to be_an(String)
    expect(item[:data][:message]).to eq("Merchant not found")

  end

  it 'find a single item which matches a min search term' do
    o_items = create_list(:item, 10)

    get "/api/v1/items/find?min_price=50"

    item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(item[:data]).to have_key(:id)
    expect(item[:data][:id].to_i).to be_an(Integer)

    expect(item[:data]).to have_key(:type)
    expect(item[:data][:type]).to be_an(String)

    expect(item[:data][:attributes]).to have_key(:name)
    expect(item[:data][:attributes][:name]).to be_a(String)

    expect(item[:data][:attributes]).to have_key(:description)
    expect(item[:data][:attributes][:description]).to be_a(String)

    expect(item[:data][:attributes]).to have_key(:unit_price)
    expect(item[:data][:attributes][:unit_price]).to be_a(Float)

    expect(item[:data][:attributes]).to have_key(:merchant_id)
    expect(item[:data][:attributes][:merchant_id]).to be_a(Integer)
  end

  it 'find a single item which matches a max search term' do
    o_items = create_list(:item, 10)

    get "/api/v1/items/find?max_price=75"

    item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(item[:data]).to have_key(:id)
    expect(item[:data][:id].to_i).to be_an(Integer)

    expect(item[:data]).to have_key(:type)
    expect(item[:data][:type]).to be_an(String)

    expect(item[:data][:attributes]).to have_key(:name)
    expect(item[:data][:attributes][:name]).to be_a(String)

    expect(item[:data][:attributes]).to have_key(:description)
    expect(item[:data][:attributes][:description]).to be_a(String)

    expect(item[:data][:attributes]).to have_key(:unit_price)
    expect(item[:data][:attributes][:unit_price]).to be_a(Float)

    expect(item[:data][:attributes]).to have_key(:merchant_id)
    expect(item[:data][:attributes][:merchant_id]).to be_a(Integer)
  end

  it 'find a single item which matches a min and max search term' do
    o_items = create_list(:item, 10)

    get "/api/v1/items/find?max_price=150&min_price=50"

    item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(item[:data]).to have_key(:id)
    expect(item[:data][:id].to_i).to be_an(Integer)

    expect(item[:data]).to have_key(:type)
    expect(item[:data][:type]).to be_an(String)

    expect(item[:data][:attributes]).to have_key(:name)
    expect(item[:data][:attributes][:name]).to be_a(String)

    expect(item[:data][:attributes]).to have_key(:description)
    expect(item[:data][:attributes][:description]).to be_a(String)

    expect(item[:data][:attributes]).to have_key(:unit_price)
    expect(item[:data][:attributes][:unit_price]).to be_a(Float)

    expect(item[:data][:attributes]).to have_key(:merchant_id)
    expect(item[:data][:attributes][:merchant_id]).to be_a(Integer)
  end
end
