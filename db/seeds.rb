# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
unless Server.all.any?
  ozf1 = { :name => 'ozfortress.com #1',
          :path => '/home/steam/srcds',
          :ip   => '119.15.96.156',
          :port => '27015'
        }


  servers = [ozf1]

  servers.each do |server|
    SshServer.where(
                      :name => server[:name], 
                      :path => server[:path], 
                      :ip => server[:ip], 
                      :port => server[:port]
                    ).first_or_create
  end

  puts "Seeded servers #{servers.join(', ')}" unless Rails.env.test?
end

unless ServerConfig.all.any?
  configs = [
              'owl',
              'owlfinals',
              'owlkoth',
              'owlkothfinals',
              'owlstopwatch',
              'ozfl',
              'ozflkoth',
              'ozflstopwatch',
              'push',
              'pushhalves',
              'scrim',
              'stopwatch',
              'ctf',
              'golden',
              'ultiduo',
              'highcp',
              'highctf',
              'highkoth',
              'highstopwatch',
              'ugc_HL_ctf', 
              'ugc_HL_koth', 
              'ugc_HL_standard', 
              'ugc_HL_stopwatch', 
              'ugc_HL_tugofwar'
            ]
  configs.each do |config|
    ServerConfig.create(:file => config)
  end
  puts "Seeded configs #{configs.join(', ')}" unless Rails.env.test?
end

unless Whitelist.all.any?
  whitelists = [  
                  'owl.txt',
                  'ozfl.txt',
                  'gshighlander.txt',
                  'item_whitelist_ugc_HL.txt'
                ]
  whitelists.each do |whitelist|
    Whitelist.create(:file => whitelist)
  end
  puts "Seeded whitelists #{whitelists.join(', ')}" unless Rails.env.test?
end

unless Location.all.any?
  locations = [
                {:name => "Austria",        :flag => "at"},
                {:name => "Australia",      :flag => "au"},
                {:name => "Belgium",        :flag => "be"},
                {:name => "Canada",         :flag => "ca"},
                {:name => "Czech Republic", :flag => "cz"},
                {:name => "Denmark",        :flag => "dk"},
                {:name => "England",        :flag => "en"},
                {:name => "EU",             :flag => "europeanunion"},
                {:name => "Germany",        :flag => "de"},
                {:name => "Finland",        :flag => "fi"},
                {:name => "France",         :flag => "fr"},
                {:name => "Hungary",        :flag => "hu"},
                {:name => "Ireland",        :flag => "ie"},
                {:name => "Israel",         :flag => "il"},
                {:name => "Latvia",         :flag => "lt"},
                {:name => "Netherlands",    :flag => "nl"},
                {:name => "Norway",         :flag => "no"},
                {:name => "Russia",         :flag => "ru"},
                {:name => "Scotland",       :flag => "scotland"},
                {:name => "Spain",          :flag => "es"},
                {:name => "UK",             :flag => "uk"},
                {:name => "USA",            :flag => "us"}
              ]
  locations.each do |location|
    Location.where(:name => location[:name], :flag => location[:flag]).first_or_create
  end

  unless Group.all.any?
    Group.create!(:name => "Donators")
  end
end
