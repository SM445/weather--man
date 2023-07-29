# frozen_string_literal: true

require 'csv'
require_relative 'date_formatter'
require_relative 'month_abbrevation'

module WeatherAnalysis
  include DateFormatter
  include Months

  def read_files(year, path)
    regular_expression = Regexp.new year.to_s     # Get names of all files having same year
    file_murree = Dir[path]
    file_murree.grep(regular_expression)
  rescue Errno::ENOENT => e
    puts "Error: #{e.message} (File not found)"
  rescue Errno::EACCES => e
    puts "Error: #{e.message} (Permission denied)"
  rescue StandardError => e
    puts "Error: #{e.message} (Unknown error)"
  end

  def temp_year(city_files)
    max_temperatures = []
    min_temperatures = []
    humidities = []

    city_files.each do |each_month|
      file = File.readlines(each_month)

      temperatures = file[1..].map do |line|
        line.chomp.split(',').then do |columns|
          [columns[0], columns[1].to_i, columns[3].to_i, columns[7].to_i]
        end
      end

      max_temperatures << temperatures.compact.max_by { |data| data[1] } if temperatures.any? { |data| data[1] }
      if temperatures.any? do |data|
           !data[2].nil? && data[2] != 0
         end
        min_temperatures << temperatures.reject do |data|
                              data[2].nil? || (data[2]).zero?
                            end.min_by { |data| data[2] }
      end
      humidities << temperatures.compact.max_by { |data| data[3] } if temperatures.any? { |data| data[3] }
    end

    max_temp = max_temperatures.compact.max_by { |data| data[1] }
    min_temp = min_temperatures.compact.min_by { |data| data[2] }
    max_humidity = humidities.compact.max_by { |data| data[3] }

    date_max_temp = format_date(max_temp[0]) if max_temp
    date_min_temp = format_date(min_temp[0]) if min_temp
    date_max_humid = format_date(max_humidity[0]) if max_humidity

    puts "Highest : #{max_temp[1]}C on #{date_max_temp}" if max_temp
    puts "Lowest : #{min_temp[2]}C on #{date_min_temp}" if min_temp
    puts "Humidity : #{max_humidity[3]}% on #{date_max_humid}" if max_humidity
  end

  def read_files_month(year, month, path)
    month_abb = month_to_abbreviation(month)
    file_name = year.to_s << '_' << month_abb
    regular_expression = Regexp.new file_name
    file_murree = Dir[path]
    file_murree.grep(regular_expression)
  rescue Errno::ENOENT => e
    puts "Error: #{e.message} (File not found)"
  rescue Errno::EACCES => e
    puts "Error: #{e.message} (Permission denied)"
  rescue StandardError => e
    puts "Error: #{e.message} (Unknown error)"
  end

  def temp_month(city_files)
    max_temps = []
    min_temps = []
    humidities = []

    max_temp_data = []
    min_temp_data = []
    max_humid_data = []

    city_files.each do |each_month|
      file = File.readlines(each_month)
      temperatures = file[1..].map do |line|
        line.chomp.split(',').then do |columns|
          [columns[0], columns[1].to_i, columns[3].to_i, columns[7].to_i]
        end
      end

      max_temp_data = temperatures.compact.max_by { |data| data[1] }
      min_temp_data = temperatures.reject { |data| data[2].nil? || data[2].zero? }.min_by { |data| data[2] }
      max_humid_data = temperatures.compact.max_by { |data| data[3] }

      max_temps << max_temp_data[1] if max_temp_data
      min_temps << min_temp_data[2] if min_temp_data
      humidities << max_humid_data[3] if max_humid_data
    end
    max_temps.reject!(&:nil?)
    min_temps.reject!(&:nil?)
    humidities.reject!(&:nil?)

    date_max_temp = format_date(max_temp_data[0]) if max_temp_data
    date_min_temp = format_date(min_temp_data[0]) if min_temp_data
    date_max_humid = format_date(max_humid_data[0]) if max_humid_data

    max_temp = max_temps.join
    min_temp = min_temps.join
    max_humidity = humidities.join

    puts "Highest : #{max_temp}C on #{date_max_temp}"
    puts "Lowest : #{min_temp}C on #{date_min_temp}"
    puts "Humidity : #{max_humidity}% on #{date_max_humid}"
  end

  def horizontal_chart(city_files)
    max = []
    min = []

    city_files.each do |each_month|
      file = File.readlines(each_month)

      file[1..].each do |line|
        columns = line.chomp.split(',')

        max_temp = columns[1].to_i
        min_temp = columns[3].to_i

        max << max_temp
        min << min_temp
      end

      max.each_with_index do |maximum, day_index|
        minimum = min[day_index]

        max_temp_bar = '+' * maximum
        min_temp_bar = '+' * minimum

        puts " #{@reset_color} #{day_index + 1} #{@blue} #{min_temp_bar} #{@red} #{max_temp_bar} #{@reset_color} #{minimum}C - #{maximum}C"
      end
    end
  end
end
