# frozen_string_literal: true

require 'csv'
require 'date'

def read_files(year, path)
  # Get names of all files having same year

  regular_expression = Regexp.new year.to_s

  # puts "#{regular_expression}"

  file_murree = Dir[path]

  file_murree.grep(regular_expression)
end

def temp_year(city_files)
  total_max_temp = []
  total_max_temp_hash = []

  total_min_temp = []
  total_min_temp_hash = []

  total_humid = []
  total_humid_hash = []

  city_files.each do |each_month|
    file = File.readlines(each_month)

    current_temp_max = nil
    current_date = nil

    current_temp_min = nil
    current_date_min = nil

    current_humid = nil
    current_date_humid = nil

    temp_max_date = {}
    temp_min_date = {}
    max_humid_date = {}

    file[1..].each do |line|
      columns = line.chomp.split(',')

      date = columns[0]
      max_temp = columns[1].to_i
      min_temp = columns[3].to_i
      max_humid = columns[7].to_i

      if current_temp_max.nil? || max_temp > current_temp_max
        current_temp_max = max_temp
        current_date = date
      end

      temp_max_date[max_temp] = date

      if current_temp_min.nil? || min_temp < current_temp_min
        current_temp_min = min_temp
        current_date_min = date
      end

      temp_min_date[min_temp] = date

      if current_humid.nil? || max_humid > current_humid
        current_humid = max_humid
        current_date_humid = date
      end

      max_humid_date[max_humid] = date
    end

    total_max_temp << current_temp_max
    total_max_temp_hash << temp_max_date

    total_min_temp << current_temp_min
    total_min_temp_hash << temp_min_date

    total_humid << current_humid
    total_humid_hash << max_humid_date
  end

  maximum_temp = total_max_temp.compact.max
  # p maximum_temp
  maximum_temp_index = total_max_temp.index(maximum_temp)
  # p maximum_temp_index
  date_corresponding = total_max_temp_hash[maximum_temp_index][maximum_temp]
  # p date_corresponding

  date_max = Date.parse(date_corresponding)
  formatted_date = date_max.strftime('%B %d')
  # puts formatted_date

  minimum_temp = total_min_temp.compact.min
  minimum_temp_index = total_min_temp.index(minimum_temp)
  date_corresponding_min = total_min_temp_hash[minimum_temp_index][minimum_temp]

  date_min = Date.parse(date_corresponding_min)
  formatted_date_min = date_min.strftime('%B %d')

  humid_temp = total_humid.compact.max
  humid_temp_index = total_humid.index(humid_temp)
  total_humid_hash[humid_temp_index][humid_temp]

  date_min = Date.parse(date_corresponding_min)
  formatted_date_humid = date_min.strftime('%B %d')

  puts "Highest : #{maximum_temp}C on #{formatted_date}"
  puts "Lowest : #{minimum_temp}C on #{formatted_date_min}"
  puts "Humidity : #{humid_temp}% on #{formatted_date_humid}"
end
