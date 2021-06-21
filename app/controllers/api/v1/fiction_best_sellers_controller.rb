class Api::V1::FictionBestSellersController < ApplicationController

  def index
    books = BookFacade.new(query)
    if books.valid_params
      render json: BookSerializer.new(books.search_results)
    else
      render json: { error: books.error_message }, status: :bad_request
    end
  end

  private

  def query
    params.permit(:rank_rising, :rank_falling, :weeks_on_list)
  end
end
