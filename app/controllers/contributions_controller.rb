class ContributionsController < ApplicationController

  def show
    @contribution = Contribution.find(params[:id])
    @investment = Investment.find(params[:investment_id])
    @contribution.investment_id = @investment
    @contributions = Contribution.all.where(investment_id: @investment.id)
  end

  def new
    @contribution = Contribution.new
    @investment = Investment.find(params[:investment_id])
    @contribution = @investment.contributions.build
  end

  def create
    @contribution = Contribution.new(contribution_params)
    @investment = Investment.find(params[:investment_id])
    @contribution.investment_id = @investment.id
    @old_contribution = Contribution.where(investment_id: @investment.id).first
    @old_contribution.destroy if @old_contribution
    if @contribution.save
      redirect_to investment_path(@investment), notice: 'Contribution created successfully.'
    else
      redirect_to investment_path(@investment), alert: "Contribution not created. errors : #{@contribution.errors.full_messages}"
    end
  end

  def edit
    @contribution = Contribution.find(params[:id])
  end

  private

  def contribution_params
    params.require(:contribution).permit(:amount, :investment_id)
  end
end
