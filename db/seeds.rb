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
puts "-> Creating categories and menu items 🇳🇱"
CATEGORY_ITEMS = {
  voorgerechten: [
    { name: 'Surf en Turf', price: 7, description: "Gebakken kleine gamba's met geplukte sparerib uit de oven, aioli.", pic_title:"surf_en_turf.jpg" },
    { name: 'Broodplankje van Rijn', price: 11, description: "Geserveerd met kruidenboter, áioli en heerlijke echte gezouten boter.", pic_title:"broodplankje.jpg" },
    { name: 'Gebakken Brie ☘️', price: 9, description: "Met gebakken champignons, bordgarnituur en bloemenhoning, crostini en balsamico.", pic_title:"gebakken_brie.jpg" },
    { name: "Gamba's Piri Piri", price: 11, description: "Gebakken gamba's, geserveerd in hete knoflook olie en chili met een broodgarnituur en aioli.", pic_title:"gambas_piri.jpg" }
  ],
  soepen: [
    { name: 'Tomatensoep ☘️', price: 7, description: "Traditionele huisgemaakte tomatensoep met pesto room en een soepstengel.", pic_title:"tomatensoep.jpg"},
    { name: 'Uiensoep ☘️', price: 7, description: "Huisgemaakte klassieke uiensoep met kaascroutons. Oma's Recept.", pic_title:"uiensoep.jpg"}
  ],
  vleesgerechten: [
    { name: 'Steak (400gr.)', price: 7, description: "Mals biefstukje geserveerd met een bordgarnituur, saus naar keuze, frites en salade.", pic_title:"steak.jpg"},
    { name: 'Ossenhaas', price: 23.5, description: "2x spiesje geregen met Malse ossenhaas 220 gram met saus naar keuze. Geserveerd met goudgele frites.", pic_title:"ossenhaas.jpg"},
    { name: 'Kippendij', price: 19, description: "Geserveerd met heerlijke pindasaus, salade, kroepoek, frites.", pic_title:"kippendij.jpg"},
    { name: 'Maaltijdsalade', price: 19, description: "Zeer rijk belegde groene frisse maaltijdsalade met runder carpaccio geserveerd met frites.", pic_title:"maaltijdsalade.jpeg"}
  ]
}

CATEGORY_ITEMS.each do |category, items|
  cat_instance = Category.create(
    name: category.to_s.capitalize,
    restaurant: Restaurant.first
    )

  items.each do |item|
    one_item = Item.create(
      name: item[:name],
      price: item[:price],
      description: item[:description],
      category: cat_instance
    )
    path = "#{Rails.root}/app/assets/images/items/#{item[:pic_title]}"
    file = File.open(path)
    one_item.picture.attach(io: file, filename: "#{item[:name]}", content_type: "image/jpg")
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
