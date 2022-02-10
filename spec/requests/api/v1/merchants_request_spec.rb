require 'rails_helper'

describe "Merchants API" do


  it "sends a list of merchants" do
    create_list(:merchant, 5)

    get '/api/v1/merchants'

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(merchants[:data].count).to eq(5)

    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id].to_i).to be_an(Integer)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end
  it "sends a list of merchants but does not include dependent data of the resource items" do

    create_list(:item, 5)

    get '/api/v1/merchants'

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(merchants[:data].count).to eq(5)

    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to_not eq("items")
    end
  end

  it 'can get one merchant by its id' do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_successful

    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:id].to_i).to be_an(Integer)

    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to be_a(String)

  end

  it "sends a list of merchants as an array even if only one merchant is found" do
    create_list(:merchant, 1)

    get '/api/v1/merchants'

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(merchants[:data].count).to eq(1)
    expect(merchants[:data]).to be_an(Array)

    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id].to_i).to be_an(Integer)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it "fetch all merchants reutrns an array even if no merchants are found" do

    get '/api/v1/merchants'

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(merchants[:data].count).to eq(0)
    expect(merchants[:data]).to be_an(Array)
  end

  it "shows merchants for a given item" do
    items = create_list(:item, 5)
    item = items.first

    get "/api/v1/items/#{item.id}/merchant"

    merchant = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_successful
    expect(merchant[:data]).to_not be_an(Array)

    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:id].to_i).to be_an(Integer)

    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to be_a(String)

  end

  it "find all merchants which match a search term" do
    o_merchants = create_list(:merchant, 20)

    get '/api/v1/merchants/find_all?name=inc'

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id].to_i).to be_an(Integer)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end
end
