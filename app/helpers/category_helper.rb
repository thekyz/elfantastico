module CategoryHelper

  class Product
    attr_accessor :id, :name, :reference, :category, :unitprice, :imageuri, :brand, :description

    def initialize(entry)
      @id = entry["id"][1]
      @name = entry["productname"][0]
      @reference = entry["reference"][0]
      @category = entry["category"][1]
      @unitprice = entry["unitprice"][0]
      if entry["imageurl"][0] == {}
        @imageuri = "no_image.gif"
      else
        @imageuri = entry["imageurl"][0]
      end
      @brand = entry["brand"][0]
      @description = entry["productdescription"][0]
    end

    def to_s
      @name
    end
  end

  # Return a title on a per-page basis.
  def items
    book = Spreadsheet.open 'data.xls'
    sheet1 = book.worksheet 0

    sheet1.each do |row|
      if row[3].downcase == @category
        "<p>#{row[1]}</p>"
      end
    end
  end

  # Returns the complete list of items for this category
  def items
    itemList = Array.new []

    # Obtain the listfeed
    listfeed_doc = get_listfeed

    # Iterate through the feed
    unless listfeed_doc["entry"].nil?
      listfeed_doc["entry"].each do |entry|
        if entry["category"][1] == @category
          # Add this item
          itemList.push(Product.new(entry))
        end
      end
    end

    # Return the set as array
    return itemList.to_a
  end
end

