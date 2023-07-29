# frozen_string_literal: true

require 'date'

module Months
  def month_to_abbreviation(month)
    return nil unless (1..12).cover?(month)

    Date::ABBR_MONTHNAMES[month]
  end
end
