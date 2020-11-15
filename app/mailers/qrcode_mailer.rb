class QrcodeMailer < ApplicationMailer

  def send_qr_code_email
    @restaurant = params[:restaurant]
    attachments.inline["qr-code-example.png"]  = File.read("#{Rails.root}/app/assets/images/qr-code-example.png")

    mail(
      to: @restaurant.email,
      subject: "QR Code - #{@restaurant.name}"
      )
  end
end

