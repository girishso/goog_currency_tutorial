$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'goog_currency'
require 'fakeweb'

valid_response =<<-VALID
  {lhs: "1 U.S. dollar",rhs: "54.836587 Indian rupees",error: "",icc: true}
VALID

valid_response_jpy =<<-VALID
{lhs: "1 U.S. dollar",rhs: "98.5124618 Japanese yen",error: "",icc: true}
VALID

invalid_response =<<-INVALID
{lhs: "",rhs: "",error: "4",icc: false}
INVALID

describe "GoogCurrency" do
  describe "valid currencies" do
    it "converts USD to INR" do
      FakeWeb.register_uri(:get,
                           "http://www.google.com/ig/calculator?hl=en&q=1USD=?INR",
                           :status => "200",
                           :body => valid_response)
      usd = GoogCurrency.usd_to_inr(1)
      usd.should == 54.836587
    end

    it "converts USD to JPY" do
      FakeWeb.register_uri(:get,
                           "http://www.google.com/ig/calculator?hl=en&q=1USD=?JPY",
                           :status => "200",
                           :body => valid_response_jpy)
      jpy = GoogCurrency.usd_to_jpy(1)
      jpy.should == 98.5124618
    end
  end

  describe "invalid currencies" do
    it "throws exception for USD to INX" do
      FakeWeb.register_uri(:get,
                           "http://www.google.com/ig/calculator?hl=en&q=1USD=?INX",
                           :status => "200",
                           :body => invalid_response)
      expect { GoogCurrency.usd_to_inx(1) }.to raise_error
    end
  end
end
