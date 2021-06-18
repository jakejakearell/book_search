require "rails_helper"

RSpec.describe "Fiction book search endpoint" do

  describe "Happy Path" do
    it "returns a current list of the top 10 best sellers w/o queries params" do
      VCR.use_cassette('happy_path_ficton_no_params') do
        get "/api/v1/fiction_best_sellers"

        body = JSON.parse(response.body, symbolize_names: true)
        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(body).to be_a(Hash)
        expect(body).to have_key(:data)
        expect(body[:data]).to be_a(Array)
        expect(body[:data].count).to eq(10)

        body[:data].each do |book|
          expect(book.keys).to eq([:id, :type, :attributes])
          expect(book[:id]).to eq("nil")
          expect(book[:type]).to eq("book")
          expect(book[:attributes].keys).to eq([
                                                :author,
                                                :title,
                                                :rank,
                                                :previous_rank,
                                                :weeks_on_list
                                                ])
          expect(book[:attributes][:author]).to be_a(String)
          expect(book[:attributes][:title]).to be_a(String)
          expect(book[:attributes][:rank]).to be_a(Integer)
          expect(book[:attributes][:previous_rank]).to be_a(Integer)
          expect(book[:attributes][:weeks_on_list]).to be_a(Integer)
        end
      end
    end

    it "can sort books by number of weeks of on the best sellers list " do
      get "/api/v1/fiction_best_sellers"

      body = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(body).to be_a(Hash)
      expect(body).to have_key(:data)

    end

    it "can filter books by those rising up the best sellers list" do
      get "/api/v1/fiction_best_sellers"

      body = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(body).to be_a(Hash)
      expect(body).to have_key(:data)
    end

    it "can filter books by those falling down the best sellers list" do
      get "/api/v1/fiction_best_sellers"

      body = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(body).to be_a(Hash)
      expect(body).to have_key(:data)

    end
  end

  describe "Sad Path and Edge Case" do
    it "returns an error if an users asks for rising and falling books" do
      get "/api/v1/fiction_best_sellers/10000000"

      data = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

    end
  end
end
