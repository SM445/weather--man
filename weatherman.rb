# frozen_string_literal: true

require_relative 'weatherman_year'
require_relative 'weatherman_month'
require_relative 'horizontal_chart'

a = read_files(2004, 'Murree_weather/*')
temp_year(a)

print "\n"

b = read_files_month(2004, 'Aug', 'Murree_weather/*')
temp_month(b)

print "\n"

horizontal_chart(b)
