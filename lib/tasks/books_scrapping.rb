require 'nokogiri'
require 'open-uri'
require 'pry'
require 'mongo'
require 'faker'
require 'securerandom'

# Fetch and parse HTML document
doc = Nokogiri::HTML(open('https://www.google.com/search?q=book+covers&tbm=isch&source=univ&sa=X&ved=2ahUKEwi-g7r81ZvlAhVCO48KHVaBBD0QsAR6BAgGEAE&biw=1299&bih=669'))
cover_images = doc.css('//img').map{ |l| p l.attr('src') }

client = Mongo::Client.new('mongodb://127.0.0.1:27017/books_app_development')
collection = client[:books]

100.times.each do
	params = { 
				title: Faker::Book.title, 
				author: Faker::Book.author,
				publisher: Faker::Book.publisher,
				cover_image: cover_images.sample,
				published_on: Faker::Date.between(from: 100.year.ago, to: Date.today),
				price: rand(10..6000),
				rating: rand(1.0..5.0)
			}
	result = collection.insert_one(params)
end

# book_images = doc.search('//img').each do |p|
	# binding.pry
# 	puts p
# end