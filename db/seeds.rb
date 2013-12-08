# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

wiki = Wiki.find_or_create_by_title 'testwiki'

# create pages 1 to 10
(1..10).each { |n| wiki.pages.create title: n.to_s, page_ident: n.to_s }

links = [
  [1, 2], [2, 3], [3, 4], [4, 5],
  [1, 6], [7, 1], [2, 7], [3, 8],
  [8, 3], [4, 8], [4, 9], [4, 10],
  [5, 10], [10, 5], [6, 7], [9, 10]
]

links.each do |from, to|
  puts "#{from} -> #{to}"
  from = Page.where(title: from.to_s, wiki: wiki).first
  to = Page.where(title: to.to_s, wiki: wiki).first
  Link.create from: from, to: to
end
