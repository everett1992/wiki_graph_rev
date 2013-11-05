desc "Download wiki dumps and parse them"
task :wiki, [:wiki] => 'wiki:all'

namespace :wiki do
  task :all, [:wiki] => 'parse:all'

  desc "Parse all dumps"
  task :parse, [:wiki] => 'parse:all'

  namespace :parse do
    task :all, [:wiki] => [:pages, :pagelinks]

    desc "Read wiki page dumps from lib/assests into the database"
    task :pages, [:wiki] => :environment do |t, args|
      indent "Creating #{args[:wiki]} pages"
      wiki = Wiki.find_or_create_by_title args[:wiki]
      wiki.get_pages
    end

    desc "Read wiki pagelink dumps from lib/assests into the database"
    task :pagelinks, [:wiki] => :environment do |t, args|
      indent "Creating #{args[:wiki]} page links"
      wiki = Wiki.find_or_create_by_title args[:wiki]
      wiki.get_page_links
    end
  end
end

def indent *args
  print ":: "
  puts args
end
