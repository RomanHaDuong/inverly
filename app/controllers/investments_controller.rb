class InvestmentsController < ApplicationController
  def new
    @etf = Etf.find(params[:etf_id])
    @investment = @etf.investments.build
  end


  def create
    counter = current_user.investments.count
    @etf = Etf.find(params[:etf_id])
    @investment = @etf.investments.build(investment_params)
    @investment.user = current_user
    if @investment.name.blank?
      @investment.name = "investment n°#{counter + 1}"
    end

    if @investment.save
      redirect_to investment_path(@investment), notice: 'Investment created successfully.'
    else
      redirect_to etf_path(@etf), alert: 'Investment not created. Please try again.'
    end
  end

  def index
    @investments = Investment.all.where(user: current_user)
  end

  def show
    @investment = Investment.find(params[:id])
    @contribution = Contribution.new
    @contribution.investment_id = @investment
    counts = @investment.contributions.pluck(:date, :total)
    counter = 5

    @cumul_count = counts.each_with_object([]) do |(date, count), result|
      counter += 1
      # Only process every 6th contribution
      next unless counter % 6 == 0

      result << [date, count]
    end

    @contributions = Contribution.all.where(investment: @investment)
  end

  private

  def investment_params
    params.require(:investment).permit(:name, :description, :risk_level, :etf_id)
  end
end
