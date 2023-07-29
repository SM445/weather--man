# frozen_string_literal: true

require_relative 'weather_class'

weather_man = WeatherMan.new

if ARGV.length == 3
  option = ARGV[0]
  year = ARGV[1]
  path = ARGV[2].slice(1..-1) if ARGV[2].start_with?('/')
  path << '*'

  case option
  when '-e'
    weather_man.yearly_temp(year.to_i, path)
  when '-a'
    # Analyze and display weather data for a specific month
    year_month = year.split('/')
    year = year_month[0].to_i
    month = year_month[1].to_i
    weather_man.monthly_temp(year, month, path)
  when '-c'
    year_month_day = year.split('/')
    year = year_month_day[0].to_i
    month = year_month_day[1].to_i
    weather_man.monthly_chart(year, month, path)
  else
    puts "Invalid option. Use '-e' to analyze by year, '-a' to analyze by month, or '-c' to analyze horizontal chart."
    puts 'Example: ruby main.rb -e 2002 /path/to/filesFolder'
    puts 'Example: ruby main.rb -a 2005/6 /path/to/files'
    puts 'Example: ruby main.rb -c 2011/03 /path/to/files'
  end
else
  puts 'Usage: ruby main.rb <option> <year/month/day> <path>'
  puts 'Example: ruby main.rb -e 2002 /path/to/filesFolder'
  puts 'Example: ruby main.rb -a 2005/6 /path/to/files'
  puts 'Example: ruby main.rb -c 2011/03/15 /path/to/files'
end
