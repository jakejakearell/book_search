require 'rails_helper'

RSpec.describe 'Book Service' do
  describe 'Happy Paths' do
    it 'will establish a connection to the book service for a location' do
      VCR.use_cassette('book_service_test') do
        service = BookService.fiction_best_sellers

        expect(service).to be_a(Hash)
        expect(service.count).to eq(5)
        expect(service.keys).to eq([:status, :copyright, :num_results, :last_modified, :results])
        expect(service[:status]).to be_a(String)
        expect(service[:copyright]).to be_a(String)
        expect(service[:num_results]).to be_a(Integer)
        expect(service[:last_modified]).to be_a(String)
        expect(service[:results]).to be_a(Array)
        expect(service[:results].count).to eq(15)

        service[:results].each do |book|
          expect(book).to be_a(Hash)
          expect(book.count).to eq(13)
          expect(book.keys).to eq([:list_name,
                                   :display_name,
                                   :bestsellers_date,
                                   :published_date,
                                   :rank,
                                   :rank_last_week,
                                   :weeks_on_list,
                                   :asterisk,
                                   :dagger,
                                   :amazon_product_url,
                                   :isbns,
                                   :book_details,
                                   :reviews])

          expect(book[:rank]).to be_a(Integer)
          expect(book[:rank_last_week]).to be_a(Integer)
          expect(book[:weeks_on_list]).to be_a(Integer)
        end
      end
    end
  end
end
