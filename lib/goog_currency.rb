require "rest_client"
require "json"

module GoogCurrency
  def self.usd_to_inr(amount)
    response = RestClient.get("http://www.google.com/ig/calculator?hl=en&q=#{amount}USD=?INR").body

    # hack to convert API response to valid JSON
    response.gsub!(/(lhs|rhs|error|icc)/, '"\1"')
    response_hash = JSON.parse(response)
    response_hash['rhs'].to_f
  end

  def self.method_missing(meth, *args)
    from, to = meth.to_s.split("_to_")

    super(meth, *args) and return if from.nil? or from == "" or to.nil? or to == ""

    response = RestClient.get("http://www.google.com/ig/calculator?hl=en&q=#{args.first}#{from.upcase}=?#{to.upcase}").body

    # response is not valid json
    response.gsub!(/(lhs|rhs|error|icc)/, '"\1"')
    response_hash = JSON.parse(response)

    response_hash['rhs'].to_f
  end
end
