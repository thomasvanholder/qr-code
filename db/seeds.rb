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
  file = File.open("#{Rails.root}/app/assets/images/witte_vogel.png")
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
    { name: "Gamba's Piri Piri 🌶", price: 11, description: "Gebakken gamba's, geserveerd in hete knoflook olie en chili met een broodgarnituur en aioli.", pic_title:"gambas_piri.jpg" }
  ],
  soepen: [
    { name: 'Tomatensoep ☘️', price: 7, description: "Traditionele huisgemaakte tomatensoep met pesto room en een soepstengel.", pic_title:"tomatensoep.jpg"},
    { name: 'Uiensoep ☘️', price: 7, description: "Huisgemaakte klassieke uiensoep met kaascroutons. Oma's Recept.", pic_title:"uiensoep.jpg"}
  ],
  vleesgerechten: [
    { name: 'Steak (400gr.)', price: 7, description: "Mals biefstukje geserveerd met een bordgarnituur, saus naar keuze, frites en salade.", pic_title:"steak.jpg"},
    { name: 'Ossenhaas', price: 23.5, description: "2x spiesje geregen met Malse ossenhaas 220 gram met saus naar keuze. Geserveerd met goudgele frites.", pic_title:"ossenhaas.jpg"},
    { name: 'Kippendij', price: 19, description: "Geserveerd met heerlijke pindasaus, salade, kroepoek, frites.", pic_title:"kippendij.jpg"},
  ],
  # visgerechten: [
  #   { name: 'Scholfilet', price: 20, description: "Geserveerd met huisgemaakte renroulade saus, bordgarnituur, goudgele frites en een frisse salade.", pic_title:"scholfilet.jpg"},
  #   { name: 'Preistamppot met zalm', price: 22, description: "Heerlijke smeuïge stamppot met geroerbakte prei en zalm uit de oven met een mosterd dille marinade", pic_title:"preistamppot_zalm.jpg"},
  #   { name: 'Maaltijdsalade', price: 19, description: "Zeer rijk belegde groene frisse maaltijdsalade met huisgerookte zalm geserveerd met frites.", pic_title:"maaltijdsalade.jpeg"}
  # ],
  # desserts: [
  #   { name: 'Notenijs', price: 8, description: "Huisgemaakt notenijs met merengue roomkaramel en karamelsaus.", pic_title:"notenijs.jpg"},
  #   { name: 'Verwenkoffie', price: 6.5, description: "Likeur of whisky in de koffie, toef slagroom en eenbonbon", pic_title:"verwenkoffie.jpg"},
  #   { name: 'Creme de Catalana', price: 7, description: "Heerlijk romig ,geserveerd met vanille ijs en aardbeien saus.", pic_title:"catalana.jpg"},
  #   { name: 'Ouderwets Lekekr', price: 6, description: "Advocaatje xl met een lekkere toef slagroom en een Belgische bonbon.", pic_title:"advocaat.jpg"}
  # ],
  bieren: [
    { name: 'palm', price: 3.8},
    { name: 'duvel', price: 4.8},
    { name: 'affligem blond', price: 4.5},
    { name: 'amstel radler', price: 3.8},
    { name: 'amstel radler 0%', price: 3.4},
    { name: 'heinken', price: 3.4},
    { name: 'Hertog Jan', price: 3.6},
  ]
}

CATEGORY_ITEMS.each do |category, items|
  cat_instance = Category.create(
    name: category.to_s.capitalize,
    restaurant: Restaurant.first
    )

  items.each do |item|
    one_item = Item.create(
      name: item[:name].capitalize,
      price: item[:price],
      description: item[:description] || nil,
      category: cat_instance
    )
    if item[:pic_title]
      path = "#{Rails.root}/app/assets/images/items/#{item[:pic_title]}"
      file = File.open(path)
      one_item.picture.attach(io: file, filename: "#{item[:name]}", content_type: "image/jpg")
    end
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

puts "#{Category.count} categories created"
puts "#{Item.count} items created"
counter = 0
Item.all.each do |item|
  counter += item.picture.attached? ? 1 : 0
end
puts "#{counter} item pictures attached"

puts stars
puts "End seed in #{(Time.now - start_time).round(2)} s"
