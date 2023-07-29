# frozen_string_literal: true

require 'date'

module DateFormatter
  def format_date(date_str)
    date = Date.parse(date_str)
    date.strftime('%B %d')
  end
end
