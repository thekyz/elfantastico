#require 'spreadsheet'

module ApplicationHelper

  # Return a title on a per-page basis.
  def title
    base_title = "Aldrick & Claire - Everything must go!"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def ss_test1
    book = Spreadsheet.open 'data.xls'
    sheet1 = book.worksheet 0

    sheet1.each do |row|
      if row[3].downcase == @title.downcase
        "<p>#{row[1]}</p>"
      end
    end
  end
end

