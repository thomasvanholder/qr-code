require_relative "../helpers/leadsCSV.rb"

class Lead < ApplicationRecord

  def self.create_leads
    loader = LeadsCSV.new
    elements = loader.load_csv
    elements.each do |el|
      Lead.create!(el)
    end
  end

  def self.send_mail
    lead = Lead.first
    # Lead.all.each do |lead|
      CampaignMailer.with(lead: lead).prospect_mail.deliver_now
    # end
  end
end



