require File.dirname(__FILE__) + "/lib/goog_currency"

get "/" do
  haml :"index"
end

post "/convert" do
  @result = GoogCurrency.send("#{params[:from]}_to_#{params[:to]}".to_sym, params[:amount])
  haml :"convert"
end
