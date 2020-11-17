class CampaignMailer < ApplicationMailer

  def prospect_mail
    @lead = params[:lead]
    # restaurant name and email, city

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
