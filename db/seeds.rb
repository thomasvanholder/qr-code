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
1.times do
  file = File.open("#{Rails.root}/app/assets/images/white_sunshine_logo.png")
  restaurant = Restaurant.new(
    name: "De Witte Vogel"
  )

  restaurant.picture.attach(io: file, filename: "logo.png", content_type: "image/png")
  # binding.pry
  restaurant.save
end
puts "#{Restaurant.count} restaurants created"

puts stars
puts "-> Categories and Menu Items 🇳🇱"
CATEGORY_ITEMS = {
  voorgerechten: [
    { name: 'Surf en Turf', price: 7, description: '' },
    { name: 'Broodplankje van Rijn', price: 11, description: '' },
    { name: 'Gebakken Brie ☘️', price: 9, description: '' },
    { name: "Gamba's Piri Piri", price: 11, description: '' }
  ],
  soepen: [
    { name: 'Tomatensoep ☘️', price: 7, description: ''},
    { name: 'Uiensoep ☘️', price: 7, description: ''}
  ],
  vleesgerechten: [
    { name: 'Vlees Trio (300gr.)', price: 7, description: ''},
    { name: 'Ossenhaas', price: 23.5, description: ''},
    { name: 'Kippendij', price: 19, description: ''},
    { name: 'Maaltijdsalade', price: 19, description: ''}
  ]
}

CATEGORY_ITEMS.each do |category, items|
  cat_instance = Category.create(
    name: category.to_s,
    restaurant: Restaurant.first
    )

  items.each do |item|
    Item.create(
      name: item[:name],
      price: item[:price],
      description: item[:description],
      category: cat_instance
    )
  end
end


# CATEGORIES_ICONS = %w[☕️ 🍲 🍽 🍨 🍿 ☘️ 🍤]
# Restaurant.all.each do |restaurant|
#   CATEGORIES.each do |category|
#     Category.create(
#       name: category.capitalize,
#       restaurant: restaurant
#     )
#   end
# end
puts "#{Category.count} categories created"


# ICONS = ['🌶', '☘',]
# puts stars
# puts "-> Creating menu items"
# Category.all.each do |category|
#     icon = rand(1..5) > 3 ? " #{ICONS.sample}" : " "
#     4.times do
#       menu_item = Item.new(
#         name: Faker::Food.dish + icon,
#         price: rand(5..25),
#         description: Faker::Food.description.slice(0..65),
#         category: category
#       )
#       file = URI.open("https://source.unsplash.com/400x300/?#{category.name.split.first}")
#       menu_item.picture.attach(io: file, filename: "food.png", content_type: "image/png")
#       menu_item.save
#     end
# end
puts "#{Item.count} items created"

puts stars
puts "End seed in #{(Time.now - start_time).round(2)} s"
