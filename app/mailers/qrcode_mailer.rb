class QrcodeMailer < ApplicationMailer

  def send_qr_code_email
    @restaurant = params[:restaurant]


    # attachments.inline["QR Code Menu - #{@restaurant.name}.svg"] = @restaurant.qr_code
    attachments.inline["qr-code-example.png"] = File.read('../assets/images/qr-code-example.png')


    mail(
      to: @restaurant.email,
      subject: "QR Code - #{@restaurant.name}"
      )
  end
end

