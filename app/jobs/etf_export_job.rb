class EtfExportJob < ApplicationJob
  queue_as :default

  def perform
    etfs = Etf.includes(:monthly_times, :holdings).map do |etf|
      {
        id: etf.id,
        name: etf.name,
        ticker_symbol: etf.ticker_symbol,
        category: etf.category,
        description: etf.description,
        historical_data: etf.historical_data,
        current_price: etf.current_price,
        average_return: etf.average_return,
        inception_date: etf.inception_date,
        created_at: etf.created_at,
        updated_at: etf.updated_at,
        monthly_times: etf.monthly_times.map do |monthly_time|
          {
            id: monthly_time.id,
            date_close_price: monthly_time.date_close_price,
            created_at: monthly_time.created_at,
            updated_at: monthly_time.updated_at,
            etf_id: monthly_time.etf_id
          }
        end,
        holdings: etf.holdings.map do |holding|
          {
            id: holding.id,
            symbol: holding.symbol,
            description: holding.description,
            weight: holding.weight,
            created_at: holding.created_at,
            updated_at: holding.updated_at,
            etf_id: holding.etf_id
          }
        end
      }
    end

    # Save to a JSON file
    file_path = Rails.root.join("db", "etf_data.json")
    File.open(file_path, "w") do |file|
      file.write(JSON.pretty_generate(etfs))
    end

    puts "ETF data exported successfully to #{file_path}"
  end
end
