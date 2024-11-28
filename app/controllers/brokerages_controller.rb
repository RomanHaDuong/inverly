class BrokeragesController < ActionController
  def index
    @brokerages = Brokerage.all
  end

  def show
    @brokerage = Brokerage.find(params[:id])
  end
end

# Interactive Brokers: https://www.interactivebrokers.com
# Firstrade: https://www.firstrade.com
# Charles Schwab: https://www.schwab.com/td-ameritrade
# Vanguard: https://investor.vanguard.com
# Fidelity: https://www.fidelity.com
# Moomoo: https://www.moomoo.com/us/
