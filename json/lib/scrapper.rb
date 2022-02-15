require 'rubygems'
require 'nokogiri' 
require 'open-uri'

class Scrapper

  attr_accessor :array_link, :name


  def initialize
    @name = Array.new
    @array_link = Array.new

  end


  def get_townhall_urls
       
       page = Nokogiri::HTML(URI.open("http://annuaire-des-mairies.com/val-d-oise.html"))
     
       page.xpath('//p/a[@class="lientxt"]').each do |link|
           array_link << link["href"][1..-1]
       end

      return array_link
  end



  def get_townhall_email(urls = get_townhall_urls)
   
    city_email_array = []

    urls.each do |url|
    page = Nokogiri::HTML(URI.open("https://www.annuaire-des-mairies.com#{url}"))
   

    page.xpath('//section[2]/div/table/tbody/tr[4]/td[2]').each do |link|
      city_email_array << link.text
   end
    puts city_email_array
    
    end

  end

  def cities_name
      
      page = Nokogiri::HTML(URI.open("http://annuaire-des-mairies.com/val-d-oise.html"))

      valedoise_cities = page.xpath('//a[@class=\'lientxt\']')
      valedoise_cities.each do |city|
          name << city.text
      end
     
      return name
      
  end

  def save_as_json
    File.open("/Users/berangerehermann/desktop/thp/json/email.json","w") do |f|
      f.write(@final_result.to_json)
    end
  end

  def save_as_spreadsheet
      session = GoogleDrive::Session.from_config("config.json")
      ws = session.spreadsheet_by_key("1FdoU0b4ZZOb4YIBsq-8y7RSg1FPYFkJk6GuuUQxCBPg").worksheets[0]
    
      credentials = Google::Auth::UserRefreshCredentials.new(
    client_id: "873505841860-lbjgidj7qf55jpa206s4avirkjt8p49c.apps.googleusercontent.com",
    client_secret: "9uhA3_l589Qpp9UfwAchZHU0",
    scope: [
      "https://www.googleapis.com/auth/drive",
      "https://spreadsheets.google.com/feeds/",
    ],
    redirect_uri: "http://example.com/redirect")
    auth_url = credentials.authorization_uri

  end

  def perform

    result = Hash[cities_name.zip(get_townhall_urls)]
    @final_result = []

    result.each do |name, value|
    @final_result << {name => value}
    
    save_as_json

    save_as_spreadsheet

    end


    return @final_result


  end

end





