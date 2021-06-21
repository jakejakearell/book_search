require "rails_helper"

RSpec.describe "BookFacade" do
  describe 'instance methods' do
    it '#save_search?' do
      VCR.use_cassette("save_search?") do
        rank_rising = BookFacade.new({:rank_rising => "true"}).save_search?
        expect(rank_rising.class).to eq(Search)

        rank_rising_2 = BookFacade.new({:rank_rising => "true"}).save_search?
        expect(rank_rising_2).to eq(nil)
      end
    end

    it '#rank_rising' do
      VCR.use_cassette("rank_rising") do
        rank_rising = BookFacade.new({:rank_rising => "true"}).filter
        rank_rising.each do |book|
          book_rank = book.rank
          book_rank_last_week = book.previous_rank
          book_rank_last_week = 999 if book_rank_last_week == 0

          expect(book_rank).to be < book_rank_last_week
        end
      end
    end

    it '#rank_falling' do
      VCR.use_cassette("rank_falling") do
        rank_falling = BookFacade.new({:rank_falling => "true"}).filter
        rank_falling.each do |book|
          book_rank = book.rank
          book_rank_last_week = book.previous_rank

          expect(book_rank).to be > book_rank_last_week
        end
      end
    end

    it '#weeks_on_list' do
      VCR.use_cassette("weeks_on_list") do
        weeks_on_list = BookFacade.new({:weeks_on_list => "true"}).sort
        top_rank = weeks_on_list.first.weeks_on_list
        weeks_on_list.each do |book|
          expect(book.weeks_on_list).to be <= top_rank
        end
      end
    end

    it '#valid_params' do
      VCR.use_cassette("valid_params") do
        valid_params = BookFacade.new({:weeks_on_list => "true"}).valid_params
        expect(valid_params).to eq(true)
        invalid_params_1 = BookFacade.new({:rank_falling => "true", :rank_rising => "true"}).valid_params
        expect(invalid_params_1).to eq(false)
        invalid_params_2 = BookFacade.new({:weeks_on_list => "121312"}).valid_params
        expect(invalid_params_2).to eq(false)
      end
    end

    it '#search_results' do
      VCR.use_cassette("search_results") do
        search_results = BookFacade.new({:weeks_on_list => "true"}).search_results
        expect(search_results.class).to eq(Array)
        expect(search_results.first.class).to eq(OpenStruct)
      end
    end

    it '#boolean_check' do
      VCR.use_cassette("boolean_check") do
        boolean_check = BookFacade.new({:weeks_on_list => "true"}).boolean_check

        expect(boolean_check).to eq(true)
      end
    end

    it '#sort' do
      VCR.use_cassette("sort") do
        sort = BookFacade.new(Hash.new).sort

        expect(sort.class).to eq(Array)
        expect(sort.first.class).to eq(OpenStruct)
      end
    end
  end
end
