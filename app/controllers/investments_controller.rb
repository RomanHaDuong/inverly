class InvestmentsController < ApplicationController
  def new
    @etf = Etf.find(params[:etf_id])
    @investment = @etf.investments.build
  end


  def create
#     @investment = Investment.new(investment_params)
#     @investment.user = current_user

#     number_of_months = 12 * 30 # 30 years of simulation, 360 months
#     number_of_months.times do |month_index|
#       date = (Date.today + month_index.months).beginning_of_month
#       Contribution.new(
#         default_contribution: 100,
#         date: date,
#         investment: @investment,
#       )

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
    @etf = @investment.etf
    beginning_value = @etf.earliest_monthly_time_price
    ending_value = @etf.latest_monthly_time_price
    inception_year = @etf.inception_date&.year
    # OLD METHOD
    # @average_rate_of_return = average_rate_of_return(beginning_value, ending_value, inception_year)
    @average_rate_of_return = @etf.average_rate_of_return
    @conservative_rate_of_return = conservative_rate_of_return(@average_rate_of_return)
    @optimistic_rate_of_return = optimistic_rate_of_return(@average_rate_of_return)
    number_of_months_for_table = [36, 60 , 84, 120, 180, 240, 360]
    @future_values_for_table = future_value(100, @average_rate_of_return, number_of_months_for_table)
    number_of_months_for_graph = [36, 72, 108, 144, 180, 216, 252, 288, 324, 360]
    @future_values_for_graph = future_value(100, @average_rate_of_return, number_of_months_for_graph)
    @contributions = @investment.contributions
    @contribution = Contribution.new

    @contribution.investment_id = @investment
    counts = @investment.contributions.pluck(:date, :amount)
    sum = 0
    @cumul_count = counts.map do | date, count|
     sum = sum + count
     [date, sum]
    end
    @contributions = Contribution.all.where(investment: @investment)
  end

  # Adam's method for the graph display
  #
  # @contribution.investment_id = @investment
  # counts = current_user.contributions.pluck(:date, :amount)
  # sum = 0
  # @cumul_count = counts.map do | date, count|
  #   sum = sum + count
  #   [date, sum]
  # end

  private

  def investment_params
    params.require(:investment).permit(:name, :description, :risk_level, :etf_id)
  end

  # def average_rate_of_return(beginning_value = rand((100.0)..(150.0)), ending_value = rand((450.0)..(500.0)), inception_year = rand(2000..2010))
  #   ((ending_value.fdiv(beginning_value)) ** (1.0 / (2024 - inception_year))) - 1
  # end

  # WARNING: This method should not be used in the controller. It should be used in the model.
  def average_rate_of_return(beginning_value, ending_value, inception_year)
    ((((ending_value.fdiv(beginning_value)) ** (1.0 / (2024 - inception_year))) - 1.0) * 100).round(3)
  end

  def conservative_rate_of_return(average_rate_of_return)
    average_rate_of_return * 0.8
  end

  def optimistic_rate_of_return(average_rate_of_return)
    average_rate_of_return * 1.2
  end

  def future_value(default_contribution = 100, rate_of_return, number_of_months)
    future_values = {}
    number_of_months.each do |number_of_month|
       future_values[number_of_month/12] = (default_contribution * (1 + (rate_of_return / 12)) ** number_of_month - 1) / (rate_of_return / 12)
    end
    future_values
  end

end
