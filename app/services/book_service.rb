class BookService
  def self.service_call
    conn.get("svc/books/v3/lists.json?") do |request|
      request.params['list'] = 'combined-print-and-e-book-fiction'
    end
  end

  def self.fiction_cache
    Rails.cache.fetch("fiction_list", :expires_in => 1.week) do
      service_call
    end
  end

  def self.fiction_best_sellers
    response = fiction_cache
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
