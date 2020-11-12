# Preview all emails at http://localhost:3000/rails/mailers/qrcode_mailer
class QrcodeMailerPreview < ActionMailer::Preview
  def send_qr_code_email
    QrcodeMailer.with(restaurant: Restaurant.first).send_qr_code_email.deliver_now
  end
end
