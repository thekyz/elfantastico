module CategoryHelper

  # Return a title on a per-page basis.
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

