json.extract! book, :id, :title, :author, :publisher, :cover_image, :published_on, :rating, :price
json.url book_url(book, format: :json)
