require "rest_client"
require "json"

module GoogCurrency
  def self.method_missing(meth, *args)
    from, to = meth.to_s.split("_to_")

    super(meth, *args) and return if from.nil? or from == "" or to.nil? or to == ""

    response = RestClient.get("http://www.google.com/ig/calculator?hl=en&q=#{args.first}#{from.upcase}=?#{to.upcase}").body

    # response is not valid json
    response.gsub!(/(lhs|rhs|error|icc)/, '"\1"')
    response_hash = JSON.parse(response)

    if response_hash['error'].nil? or response_hash['error'] == ""
      response_hash['rhs'].to_f
    else
      raise "An error occurred: #{response_hash['error']}"
    end
  end
end
