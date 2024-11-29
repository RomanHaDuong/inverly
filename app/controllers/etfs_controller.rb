class EtfsController < ApplicationController
  def index
    @etfs = Etf.all
  end

  def create
    @etf = Etf.new(etf_params)
    if @etf.save
      redirect_to etf_path(@etf)
    end
  end

  def show
    @etf = Etf.find(params[:id])
    @investment = Investment.new
    @investment.etf_id = @etf
    @investment.user_id = current_user
    @etfs = Etf.all.where(etf_id: @etf.id)

    @monthly_series = @etf.monthly_times
    # dates = monthly_series.keys
    # parsed_monthly_series = {}
    # dates.each do |date|
    #   parsed_monthly_series[date] = monthly_series[date]['4. close']
    # end
    @top_holdings = @etf.holdings

    # parsed_holdings = {}
    # top_holdings.each do |holding|
    #   parsed_holdings[holding] = holdings[holding]['symbol']['description']['weight']
    # end

    # beginning_value = @etf.earliest_monthly_time_price
    # ending_value = @etf.latest_monthly_time_price
    # inception_year = @etf.inception_date&.year
    # @average_rate_of_return = average_rate_of_return()
  end

  private

  def etf_params
    params.require(:etf).permit(:name, :ticker_symbol, :description, :current_price, :category, :average_return)
  end

  def average_rate_of_return(beginning_value, ending_value, inception_year)
    ((ending_value.fdiv(beginning_value)) ** (1.0 / (2024 - inception_year))) - 1
  end
end
