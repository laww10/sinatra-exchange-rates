require "sinatra"
require "sinatra/reloader"
require "http"

get("/") do

  api_url = "https://api.exchangerate.host/list?access_key=#{ENV["EXCHANGE_RATE_KEY"]}"

  raw_data = HTTP.get(api_url)
  raw_data_string = raw_data.to_s
  parsed_data = JSON.parse(raw_data_string)

  currencies = parsed_data.fetch("currencies")
  @currencies_list = []
  
  currencies.keys.each do |key|
    @currencies_list.push(key)
  end

  erb(:homepage)
end

get("/:from_currency") do
  
  @original_currency = params.fetch("from_currency")

  api_url = "https://api.exchangerate.host/list?access_key=#{ENV["EXCHANGE_RATE_KEY"]}"

  raw_data = HTTP.get(api_url)
  raw_data_string = raw_data.to_s
  parsed_data = JSON.parse(raw_data_string)

  currencies = parsed_data.fetch("currencies")
  @currencies_list = []
  
  currencies.keys.each do |key|
    @currencies_list.push(key)
  end
  
  erb(:first_currency_chosen)

end

get("/:from_currency/:to_currency") do
  @original_currency = params.fetch("from_currency")
  @destination_currency = params.fetch("to_currency")

  api_url = "https://api.exchangerate.host/convert?access_key=#{ENV["EXCHANGE_RATE_KEY"]}&from=#{@original_currency}&to=#{@destination_currency}&amount=1"

  currency_data = HTTP.get(api_url)
  currency_data_string = currency_data.to_s
  currency_parsed_data = JSON.parse(currency_data_string)

  @conversion_rate = currency_parsed_data.fetch("result")

  erb(:second_currency_chosen)
  
  # some more code to parse the URL and render a view template
end
