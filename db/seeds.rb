# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create(email: "etika@abc.com", password: "abcdefg")
vertical = Vertical.create(name: "Check")
(0..5).each do |i|
  category = vertical.categories.create(name: "Category#{i}", state: "active")
  category.courses.create(name: "Course#{i}", author: "Author#{i}",  state: "active")
end
