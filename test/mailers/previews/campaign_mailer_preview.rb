# Preview all emails at http://localhost:3000/rails/mailers/campaign_mailer
class CampaignMailerPreview < ActionMailer::Preview
  def prospect_mail
    CampaignMailer.with(lead: Lead.first).prospect_mail.deliver_now
  end
end
