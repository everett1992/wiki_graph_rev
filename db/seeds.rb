# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts "Seeding database"

wiki = Wiki.create(title: 'test')
puts "Created wiki #{wiki.title}"

page_titles = ('a'..'z')

puts "Creating pages #{page_titles.first} to #{page_titles.last}"
page_titles.each do |title|
  Page.create wiki: wiki, title: title
end

puts "Created #{Page.count} pages."

count = Page.count

Page.all.each do |page|
  n = 5
  puts "Linking '#{page.title}' to #{n} random pages"
  n.times do
    to_page = Page.find_by_id(rand(count))
    page.create_link_to(to_page)
  end
  puts "#{page.title}: #{page.linked_pages.map(&:title).join(', ')}"
end
