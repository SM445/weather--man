# frozen_string_literal: true

def horizontal_chart(city_files)
  blue = "\e[34m"
  red = "\e[31m"
  reset_color = "\e[37m"

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

      puts " #{reset_color} #{day_index + 1} #{blue} #{min_temp_bar} #{red} #{max_temp_bar} #{reset_color} #{minimum}C - #{maximum}C"
    end
  end
end
