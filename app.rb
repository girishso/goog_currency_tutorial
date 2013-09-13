require File.dirname(__FILE__) + "/lib/goog_currency"

get "/" do
  haml :"index"
end

post "/convert" do
  begin
    @result = GoogCurrency.send("#{params[:from]}_to_#{params[:to]}".to_sym, params[:amount])
  rescue Exception => ex
    @error = ex.message
  end
  haml :"convert"
end
