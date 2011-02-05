require 'set'
require 'net/http'
require 'net/https'
require 'xmlsimple'
require 'pp'

module ApplicationHelper
#  SPREADSHEET_URI = 'http://spreadsheets.google.com/feeds/spreadsheets/private/full'
  LISTFEED_URI = 'https://spreadsheets.google.com/feeds/list/tYyno1g7VX2Ismg_aub8gqA/od6/private/full'

  # Authenticates to google
  def authenticate_to_google
    http = Net::HTTP.new('www.google.com', 443)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    path = '/accounts/ClientLogin'
    data = 'accountType=HOSTED_OR_GOOGLE&Email=elfantastico666@gmail.com&Passwd=007elfanta&service=wise'
    headers = {"Content-Type"=>"application/x-www-form-urlencoded"}
    resp, data = http.post(path, data, headers)
    cl_string = data[/Auth=(.*)/, 1]
    headers["Authorization"] = "GoogleLogin auth=#{cl_string}"

    return headers
  end

  # Gets a uri feed
  def get_feed(uri, headers=nil)
    uri = URI.parse(uri)
    session = Net::HTTP.new(uri.host, uri.port)
    if uri.port == 443
      session.use_ssl = true if uri.port == 443
      session.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    session.start() do |http|
      return http.get(uri.path, headers)
    end
  end

  # Gets the first listfeed from the authenticated account
  def get_listfeed_uri
    # Fetch the sheet list
    spreadsheets = get_feed(SPREADSHEET_URI, headers)
    doc = XmlSimple.xml_in(spreadsheets.body, 'KeyAttr' => 'name')

    # Extract the spreadsheet key
    spreadsheet_key = doc["entry"][0]["id"][0][/full\/(.*)/, 1]

    # Obtain the spreadsheet feed
    worksheet_feed_uri = "http://spreadsheets.google.com/feeds/worksheets/#{spreadsheet_key}/private/full"
    worksheet_response = get_feed(worksheet_feed_uri, headers)

    # Parse the xml into a data structure
    worksheet_data = XmlSimple.xml_in(worksheet_response.body, 'KeyAttr' => 'name')

    # Obtain the worksheet
    listfeed_uri = worksheet_data["entry"][0]["link"][0]["href"]

    return listfeed_uri
  end

  # Returns the listfeed for our sheet
  def get_listfeed
    # Authenticate & generate the header for further use
    headers = authenticate_to_google
    # Fetch the listfeed from the sheet
    response = get_feed(LISTFEED_URI, headers)
    listfeed_doc = XmlSimple.xml_in(response.body, 'KeyAttr' => 'name')

    return listfeed_doc
  end

  # Returns the complete list of categories
  def categories
    categorySet = Set.new []

    # Obtain the listfeed
    listfeed_doc = get_listfeed
    #pp "id : " + listfeed_doc["entry"][0]["id"][1]
    #pp "reference : " + listfeed_doc["entry"][0]["reference"][0]
    #pp "category : " + listfeed_doc["entry"][0]["category"][1]

    logger.info "----------- Getting categories"
    # Iterate through the category column
    unless listfeed_doc["entry"].nil?
      listfeed_doc["entry"].each do |entry|
        # Try to add the category to the set
        unless categorySet.add?(entry["category"][1]).nil?
          logger.info "--- new category : " + entry["category"][1]
        end
      end
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

