class BookService
  def self.fiction_best_sellers
    response = conn.get("svc/books/v3/lists.json?") do |request|
      request.params['list'] = 'combined-print-and-e-book-fiction'
    end
    parser(response.body)
  end

  private

  def self.parser(body)
    JSON.parse(body, symbolize_names: true)
  end

  def self.conn
    Faraday.new('https://api.nytimes.com/') do |req|
      req.params['api-key'] = ENV['book_key']
    end
  end
end
