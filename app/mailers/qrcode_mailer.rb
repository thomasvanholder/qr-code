# require 'pry'

class QrcodeMailer < ApplicationMailer

  def send_qr_code_email
    @restaurant = params[:restaurant]

    link = "http://localhost3000/restaurants/" + @restaurant.id.to_s + "/qrcode?"
    attachments.inline["QR Code Menu - #{@restaurant.name}.svg"] = @restaurant.qr_code

    mail(
      to: @restaurant.email,
      subject: "QR Code - #{@restaurant.name}"
      )
  end
end

