require 'nokogiri'
require 'open-uri'
require 'sqlite3'

doc = Nokogiri::HTML(open("http://students.flatironschool.com "))

# grab students urls and return array with urls
def return_student_urls(doc)
   url_array = []
   doc.search("h3 a").each do |item|
      unless item.values[0] == "#"
         url_array << "http://students.flatironschool.com/" + "#{item.values[0].downcase}"
         puts "http://students.flatironschool.com/" + "#{item.values[0].downcase}"
      end
   end
   url_array
end

url_array = return_student_urls(doc)

# create student_name_array
@student_hash = []
def gen_student_hash (url_array)
  url_array.each_with_index do |url, index|
     begin
        student_doc = Nokogiri::HTML(open(url))
        @student_hash << {
           :name => student_doc.search('h4').first.text.strip,
           :url => url,
           :quote => student_doc.search('h3').first.text.strip,
           :bio => student_doc.search('p').first.text.strip,
           :twitter => ret_social_profile(student_doc)[0].downcase.gsub("https://twitter.com/","").gsub("http://twitter.com/",""),
           :linkedin => ret_social_profile(student_doc)[1],
           :github => ret_social_profile(student_doc)[2]
        }
     rescue OpenURI::HTTPError => ex
     end
  end
end

def ret_social_profile(url_doc)
  profile_array = []
  url_doc.search(".social-icons a").each do |item,index|
     profile_array << item.values[0]
  end
  profile_array
end

gen_student_hash(url_array)

# create db
db = SQLite3::Database.new "studentscraper.db"

# Create a database
rows = db.execute <<-SQL
  create table students (
    id INTEGER PRIMARY KEY,
    name varchar(35),
    url varchar(255),
    twitter varchar(255),
    linkedin varchar(255),
    github varchar(255),
    quote text,
    bio text
  );
SQL

@student_hash.each do |hash|
   db.execute(
      "INSERT INTO students (name, url, twitter, linkedin, github, quote, bio)
         VALUES (?, ?, ?, ?, ?, ?, ?)",
      [
        hash[:name],
        hash[:url],
        hash[:twitter],
        hash[:linkedin],
        hash[:github],
        hash[:quote],
        hash[:bio]])
end
