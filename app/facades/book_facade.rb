class BookFacade
  attr_reader :error_message

  def initialize(query)
    service_call = BookService.fiction_best_sellers
    @books = book_object_creation(service_call)
    @error_message = nil
    @query = query
  end

  def valid_params
    if @query[:rank_rising].present? && @query[:rank_falling].present?
      @error_message = "Can't include by rank_rising and rank_falling"
      false
    elsif !boolean_check
      @error_message = "Must search by 'true' or 'false'"
      false
    else
      save_search?
      true
    end
  end

  def boolean_check
    @query.values.all? do |value|
      value.downcase == "true" || value.downcase == "false"
    end
  end

  def search_results
    filter
    sort
  end

  def filter
    if @query[:rank_rising].present? && @query[:rank_rising].downcase == 'true'
      @books = rank_rising(@books)
    elsif @query[:rank_falling].present? && @query[:rank_falling].downcase == 'true'
      @books = rank_falling(@books)
    end
  end

  def sort
    if @query[:weeks_on_list].present? && @query[:weeks_on_list].downcase == 'true'
      @books = weeks_on_list(@books)
    else
      @books
    end
  end

  def rank_rising(books)
    books.find_all do | book|
      book.rank < book.previous_rank || book.previous_rank == 0
    end
  end

  def rank_falling(books)
    books.find_all do | book|
      book.rank > book.previous_rank if book.previous_rank != 0
    end
  end

  def weeks_on_list(books)
    books.sort_by do |book|
      -book.weeks_on_list
    end
  end

  def book_object_creation(service_call)
    service_call[:results].map do |book|
      OpenStruct.new(
        id: 'nil',
        author: book[:book_details].first[:author],
        title: book[:book_details].first[:title].titleize,
        rank: book[:rank],
        previous_rank: book[:rank_last_week],
        weeks_on_list: book[:weeks_on_list],
      )
    end
  end

  def save_search?
    if !Search.find_by(@query)
      Search.create(@query)
    end
  end
end
