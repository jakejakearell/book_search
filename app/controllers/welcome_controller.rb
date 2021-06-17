class WelcomeController < ApplicationController
  def index
    render json: {endpoints: "https://github.com/jakejakearell/book_search#readme"}
  end
end
