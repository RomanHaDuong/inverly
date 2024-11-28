require 'open-uri'
require 'json'

class FetchEtfData
  def initialize(etf)
    @etf = etf
  end

  def call_monthly_series
    url = "https://www.alphavantage.co/query?function=TIME_SERIES_MONTHLY&symbol=#{@etf}&apikey=#{ENV.fetch('ALPHA_VANTAGE_API_KEY')}"
    response = URI.parse(url).read
    JSON.parse(response)
  end

  def call_holdings
    url = "https://www.alphavantage.co/query?function=ETF_PROFILE&symbol=#{@etf}&apikey=#{ENV.fetch('ALPHA_VANTAGE_API_KEY')}"
    response = URI.parse(url).read
    JSON.parse(response)
  end

  private

  def url
  end
end
