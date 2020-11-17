require_relative "../services/scraper_restaurants.rb"

class LeadsController < ApplicationController

  def self.create_leads
    scraper = ScraperRestaurants.new("wien")
    leads = scraper.call
    leads.each do |lead|
      Lead.create!(lead)
    end
  end

  def self.send_mail
    unique_leads = Lead.select(:name, :email).distinct.select(&:email)
    without_empty_emails = unique_leads.select { |lead| !lead.email.empty? }

    without_empty_emails.each do |lead|
      CampaignMailer.with(lead: lead).prospect_mail.deliver_now
    end

  end
end
