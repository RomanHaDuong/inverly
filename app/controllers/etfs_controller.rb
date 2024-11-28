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
  end

  private

  def etf_params
    params.require(:etf).permit(:name, :ticker_symbol, :description, :current_price, :category, :average_return)
  end
end
