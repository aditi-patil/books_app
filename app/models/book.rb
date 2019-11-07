class Book
  include Mongoid::Document
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks  

  field :title, type: String
  field :author, type: String
  field :publisher, type: String
  field :cover_image, type: String
  field :published_on, type: Date
  field :rating, type: Float
  field :price, type: Float


  def self.get_cover_images
    doc = Nokogiri::HTML(open('https://www.google.com/search?q=book+covers&tbm=isch&source=univ&sa=X&ved=2ahUKEwi-g7r81ZvlAhVCO48KHVaBBD0QsAR6BAgGEAE&biw=1299&bih=669'))
    cover_images = doc.css('//img').map{ |l| p l.attr('src') }
  end

  def self.create_book_data
    1000.times.each do
        params = { 
                    title: Faker::Book.title, 
                    author: Faker::Book.author,
                    publisher: Faker::Book.publisher,
                    cover_image: get_cover_images.sample,
                    published_on: Faker::Date.between(from: 100.year.ago, to: Date.today),
                    price: rand(10..6000),
                    rating: rand(1.0..5.0)
                }
        result = collection.insert_one(params)
    end
  end

  def self.search(query)
   __elasticsearch__.search(
   {
      size: 100,
      query: {
        multi_match: {
          query: query,
          fields: ['title', 'author', 'published_on']
        }
      },
   })    
  end 
end
