require "rails_helper"

RSpec.describe "Fiction book search endpoint" do

  describe "Happy Path" do
    it "returns a current list of the top 15 best sellers w/o queries params" do
      VCR.use_cassette('happy_path_ficton_no_params') do
        get "/api/v1/fiction_best_sellers"

        body = JSON.parse(response.body, symbolize_names: true)
        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(body).to be_a(Hash)
        expect(body).to have_key(:data)
        expect(body[:data]).to be_a(Array)
        expect(body[:data].count).to eq(15)

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
      VCR.use_cassette('happy_path_weeks_on_list') do
        get "/api/v1/fiction_best_sellers?weeks_on_list=true"
        body = JSON.parse(response.body, symbolize_names: true)
        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(body).to be_a(Hash)
        expect(body).to have_key(:data)
        expect(body[:data]).to be_a(Array)
        expect(body[:data].count).to eq(15)

        most_weeks_on_chart = body[:data].first[:attributes][:weeks_on_list]
        body[:data].each do |book|
          expect(book[:attributes][:weeks_on_list]).to be <= most_weeks_on_chart
        end
      end
    end

    it "can filter books by those rising up the best sellers list" do
      VCR.use_cassette('happy_path_rising_on_list') do
        get "/api/v1/fiction_best_sellers?rank_rising=true"
        body = JSON.parse(response.body, symbolize_names: true)
        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(body).to be_a(Hash)
        expect(body).to have_key(:data)
        expect(body[:data]).to be_a(Array)
        expect(body[:data].count).to_not eq(15)

        body[:data].each do |book|
          book_rank = book[:attributes][:rank]
          book_rank_last_week = book[:attributes][:previous_rank]
          book_rank_last_week = 999 if book_rank_last_week == 0

          expect(book_rank).to be < book_rank_last_week
        end
      end
    end

    it "can filter books by those falling down the best sellers list" do
      VCR.use_cassette('happy_path_falling_on_list') do
        get "/api/v1/fiction_best_sellers?rank_falling=true"
        body = JSON.parse(response.body, symbolize_names: true)
        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(body).to be_a(Hash)
        expect(body).to have_key(:data)
        expect(body[:data]).to be_a(Array)
        expect(body[:data].count).to_not eq(15)

        body[:data].each do |book|
          book_rank = book[:attributes][:rank]
          book_rank_last_week = book[:attributes][:previous_rank]

          expect(book_rank).to be > book_rank_last_week
        end
      end
    end

    it "can filter books and sort the filtered list" do
      VCR.use_cassette('happy_path_sorted_filtered_list') do
        get "/api/v1/fiction_best_sellers?rank_falling=true&weeks_on_list=true"
        body = JSON.parse(response.body, symbolize_names: true)
        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(body).to be_a(Hash)
        expect(body).to have_key(:data)
        expect(body[:data]).to be_a(Array)
        expect(body[:data].count).to_not eq(15)
        require "pry"; binding.pry
        most_weeks_on_chart = body[:data].first[:attributes][:weeks_on_list]
        body[:data].each do |book|
          book_rank = book[:attributes][:rank]
          book_rank_last_week = book[:attributes][:previous_rank]

          expect(book_rank).to be > book_rank_last_week
          expect(book[:attributes][:weeks_on_list]).to be <= most_weeks_on_chart
        end
      end
    end
  end

  describe "Sad Path and Edge Case" do
    xit "returns an error if an users asks for rising and falling books" do
      get "/api/v1/fiction_best_sellers/rank_falling=true&rank_falling=true"

      data = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

    end

    xit "returns an error if an users doesn't provide true or false for query" do
      get "/api/v1/fiction_best_sellers/rank_falling=123"

      data = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

    end
  end
end
