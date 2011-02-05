require 'set'

module ApplicationHelper


  # Returns the complete list of categories
  def categories
    categorySet = Set.new []
    logger.info "----------- Getting categories"
    book = Spreadsheet.open('data.xls')
    # Iterate through the category column
    unless book.nil?
      book.worksheet(0).each 1 do |row|
        # Try to add the category to the set
        unless categorySet.add?(row[3]).nil?
          logger.info "--- new category : " + row[3]
        end
      end
    else
      return ["Electronics", "House"]
    end

    # Return the set as array
    return categorySet.to_a
  end

  # Returns a title on a per-page basis.
  def title
    base_title = "Aldrick & Claire - Everything must go!"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
end

