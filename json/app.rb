require 'bundler'
Bundler.require

require 'scrapper'
require 'json'
require 'google_drive'
require 'csv'

$:.unshift File.expand_path("./../lib", __FILE__)



Scrapper.new.perform


# def save_as_csv
#   h = @final_result

#   CSV.open("data.csv", "w", headers: h.keys) do |csv|
#     csv << h.values
#   end
# end

# save_as_csv





