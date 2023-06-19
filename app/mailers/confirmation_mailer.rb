class ConfirmationMailer < ApplicationMailer
  def confirmation_mail(confirmation)
    @confirmation = confirmation

    mail to: @confirmation.email, subject: "投稿確認メール"
  end
end
