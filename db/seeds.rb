require "faker"
require "open-uri"

Item.destroy_all
Category.destroy_all
Restaurant.destroy_all

start_time = Time.now
stars = "-" * 25
puts "Starting seeds: #{start_time}"

puts stars
puts "-> Creating restaurants"
5.times do
  file = URI.open("https://source.unsplash.com/400x300/?logo")
  restaurant = Restaurant.new(
    name: Faker::Restaurant.name
  )
  restaurant.picture.attach(io: file, filename: "logo.png", content_type: "image/png")
  restaurant.save
end
puts "#{Restaurant.count} restaurants created"

puts stars
puts "-> Creating categories"
CATEGORIES = %w[breakfast lunch dinner desert snacks vegan fish']
CATEGORIES_ICONS = %w[☕️ 🍲 🍽 🍨 🍿 ☘️ 🍤]
Restaurant.all.each do |restaurant|
  2.times do |num|
    Category.create(
      name: CATEGORIES[num] + ' ' + CATEGORIES_ICONS[num],
      restaurant: restaurant
    )
  end
end
puts "#{Category.count} categories created"

ICONS = ['🌶', '☘',]
puts stars
puts "-> Creating menu items"
Category.all.each do |category|
    icon = rand(1..5) > 3 ? " #{ICONS.sample}" : " "
    4.times do
      menu_item = Item.new(
        name: Faker::Food.dish + icon,
        price: rand(5..25),
        description: Faker::Food.description.slice(0..65),
        category: category
      )
      file = URI.open("https://source.unsplash.com/400x300/?#{category.name.split.first}")
      menu_item.picture.attach(io: file, filename: "food.png", content_type: "image/png")
      menu_item.save
    end
end
puts "#{Item.count} items created"

puts stars
puts "End seed in #{(Time.now - start_time).round(2)} s"
