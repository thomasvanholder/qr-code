class QrcodeMailer < ApplicationMailer

  def send_qr_code_email
    @restaurant = params[:restaurant]

    instance = RQRCode::QRCode.new("http://localhost3000/restaurants/#{@restaurant.id}/qrcode?")
    @svg = instance.as_svg(
      offset: 0, # no padding
      color: "000", # color black
      shape_rendering: "crispEdges",
      module_size: 6, # all modules 6px each (size)
      standalone: true
    )


    mail(to: @restaurant.email, subject: "QR Code - #{@restaurant.name}")
  end
end
