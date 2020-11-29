require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students_hashes = []
    docs = Nokogiri::HTML(open(index_url))
    students_infos = docs.css('.student-card')
    students_infos.each do |student|
      name=student.css('h4').text
      location=student.css('p').text
      profile_url=student.css('a')[0]["href"]
      student_hash={name:name,location:location,profile_url:profile_url}
      students_hashes.push(student_hash)
    end
    students_hashes
    
  end

  def self.scrape_profile_page(profile_url)
    docs = Nokogiri::HTML(open(profile_url))

    profile_name = docs.css('.profile-name').text

    hash={}

    docs.css('.social-icon-container a').each do |link|
      if link["href"].include?("twitter")
        hash[:twitter]=link["href"]
      elsif link["href"].include?("github")
        hash[:github]=link["href"]
      elsif link["href"].include?("linkedin")
        hash[:linkedin]=link["href"]
      else
        hash[:blog]=link["href"]
      end
    end

    profile_quote=docs.css('.profile-quote').text
    bio=docs.css('.description-holder p').text
    hash[:profile_quote]=profile_quote
    hash[:bio]=bio
    hash
  end

end

