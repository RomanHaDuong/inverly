# rails etf:export

namespace :etf do
  desc "turning seed data into json"
  task export: :environment do
    EtfExportJob.perform_now
  end

end
