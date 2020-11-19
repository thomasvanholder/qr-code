class CampaignMailer < ApplicationMailer

  def prospect_mail
    @lead = params[:lead]
    # restaurant name and email, city
    attachments.inline["app_example.png"] = File.read("#{Rails.root}/app/assets/images/app_example.png")

    mail(
      to: @lead.email,
      subject: "QR Code Menu für #{@lead.name}"
    )
     # link to homepage - german example?

     # schedule with Active Job?

    # change currency
     # footer
  end
end
