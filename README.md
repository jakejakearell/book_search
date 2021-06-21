# Book Search

## About

* A RESTful API analyzing the books on the New York Times fiction best-sellers list. Sort by weeks on list and filter by books performance 

## Local Setup
**Version Requirements**
* ruby 2.5.3
* rails 5.2

1. `git clone git@github.com:jakejakearell/book_search.git`
2. `cd book_search`
3. `bundle install`
4. `rails db:{create,migrate}`
5. `figaro install` (this will generate a gitignored `config/application.yml` file)
6. obtain API keys from the following services:
    * [NYT](https://developer.nytimes.com/get-started)

7. add the API keys you obtained to `application.yml`:
    ```
    book_key: <your NYT book api key>
    ```
8. run `rails s` and explore the endpoints below!

## Running the test suite
The tests are all built using the [RSpec](https://rspec.info/) and [Capybara](https://github.com/teamcapybara/capybara) test suites.

- To run the full test suite run the below in your terminal:
```
$ bundle exec rspec
```
- To run an individual test file run the below in tour terminal:
```
$ bundle exec rspec <file path>
```
for example: `bundle exec rspec spec/requests/api/v1/book_search_request_spec.rb`

## Endpoints

### Fiction Best Sellers: returns a list of the NYT best sellers for the past week
Can filter by books climbing up the best seller list or books falling down the list using params below. Trying both at the same time will result in an error.
```
rank_rising=true
rank_falling=true
```
Can sort by the number of weeks the books has been on the best seller list. This can be done in conjuction with filtering or without filtering.
```
weeks_on_list=true
```

Request: `GET https://restful-book-best-sellers.herokuapp.com/api/v1/fiction_best_sellers`  

#### Example:
Request: `https://restful-book-best-sellers.herokuapp.com/api/v1/fiction_best_sellers?rank_rising=true&weeks_on_list=true`  
Response body:
```
{
    "data": [
        {
            "id": "nil",
            "type": "book",
            "attributes": {
                "author": "Delia Owens",
                "title": "Where The Crawdads Sing",
                "rank": 6,
                "previous_rank": 8,
                "weeks_on_list": 134
            }
        },
        {
            "id": "nil",
            "type": "book",
            "attributes": {
                "author": "Alex Michaelides",
                "title": "The Silent Patient",
                "rank": 13,
                "previous_rank": 14,
                "weeks_on_list": 41
            }
        },
        {
            "id": "nil",
            "type": "book",
            "attributes": {
                "author": "Matt Haig",
                "title": "The Midnight Library",
                "rank": 10,
                "previous_rank": 11,
                "weeks_on_list": 28
            }
        },
        {
            "id": "nil",
            "type": "book",
            "attributes": {
                "author": "Kristin Hannah",
                "title": "The Four Winds",
                "rank": 14,
                "previous_rank": 15,
                "weeks_on_list": 19
            }
        },
        {
            "id": "nil",
            "type": "book",
            "attributes": {
                "author": "Madeline Miller",
                "title": "The Song Of Achilles",
                "rank": 15,
                "previous_rank": 0,
                "weeks_on_list": 10
            }
        },
        {
            "id": "nil",
            "type": "book",
            "attributes": {
                "author": "John Grisham",
                "title": "Sooley",
                "rank": 7,
                "previous_rank": 10,
                "weeks_on_list": 7
            }
        },
        {
            "id": "nil",
            "type": "book",
            "attributes": {
                "author": "Bill Clinton and James Patterson",
                "title": "The President's Daughter",
                "rank": 1,
                "previous_rank": 0,
                "weeks_on_list": 1
            }
        },
        {
            "id": "nil",
            "type": "book",
            "attributes": {
                "author": "Don Bentley",
                "title": "Tom Clancy: Target Acquired",
                "rank": 3,
                "previous_rank": 0,
                "weeks_on_list": 1
            }
        }
    ]
}
```
## Search Table

A straightforward check in the facade once the 

## Tools
Book Search is written in Ruby with Ruby on Rails and uses a PostgreSQL database.

**Language and Framework Versions**
* ruby 2.5.3
* rails 5.2

**Gems**
* Faraday
* Figaro
* FastJSON

**Testing**
* SimpleCov
* RSpec
* WebMock
* VCR
* ShouldaMatchers

** Third Party APIs
* New York Times
   * [Image search API - GET image](https://developer.nytimes.com/docs/books-product/1/overview)

## Reflections
- Could have used more performative queries. NYT Book API would only returned 15 books so this did not become a priority but would be an issue with scaling in the future 

   I also think that indexing on the search table would have been useful for performance if I am checking for the presence of a search in my db whenever someone uses this service 
- Controller is pretty clean 
- Would have liked to had a more robust search function but some of the data didn't seem correct when coming back from the API so opted for simple and working 
- Caching would probably be the next feature I would try and implement. After that probably allow for non-fiction searches and to search previous dates
