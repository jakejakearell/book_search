class BookSerializer
  include FastJsonapi::ObjectSerializer
  attributes :author, :title, :rank, :previous_rank, :weeks_on_list
end
