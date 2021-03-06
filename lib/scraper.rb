require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = File.read(index_url)
    index = Nokogiri::HTML(html)

    students = []
    #student: index.css("div.student-card")
    #name: index.css("h4.student-name").text
    #location: index.css("p.student-location").text
    #profile_url: index.css("div.student-card a").attribute("href").value

    index.css("div.student-card a").each_with_index do |student, i|
      students[i] = {
        :name => student.css("h4.student-name").text,
        :location => student.css("p.student-location").text,
        :profile_url => student.attribute("href").value
      }
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    html = File.read(profile_url)
    profile = Nokogiri::HTML(html)
    student = {}

    #twitter: profile.css("div.social-icon-container a")[0].attribute("href").value
    #linkedin: profile.css("div.social-icon-container a")[1].attribute("href").value
    #github: profile.css("div.social-icon-container a")[2].attribute("href").value
    #blog: profile.css("div.social-icon-container a")[3].attribute("href").value
    #quote: profile.css("div.profile-quote").text
    #bio: profile.css("div.description-holder p").text

    links = profile.css("div.social-icon-container a").map {|l| l.attribute("href").value}
    links.each do |link|
      if link.include?("twitter")
        student[:twitter] = link
      elsif link.include?("linkedin")
        student[:linkedin] = link
      elsif link.include?("github")
        student[:github] = link
      else
        student[:blog] = link
      end
    end

    student[:profile_quote] = profile.css("div.profile-quote").text
    student[:bio] = profile.css("div.description-holder p").text

    student
  end
end
