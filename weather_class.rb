# frozen_string_literal: true

require_relative 'weather_analysis'

class WeatherMan
  include WeatherAnalysis

  def initialize
    @blue = "\e[34m"
    @red = "\e[31m"
    @reset_color = "\e[37m"
  end

  def yearly_temp(year, path)
    city_files = read_files(year, path)
    temp_year(city_files)
  end

  def monthly_temp(year, month, path)
    city_files = read_files_month(year, month, path)
    temp_month(city_files)
  end

  def monthly_chart(year, month, path)
    city_files = read_files_month(year, month, path)
    horizontal_chart(city_files)
  end
end
