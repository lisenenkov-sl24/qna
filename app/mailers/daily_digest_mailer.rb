class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @user = user
    mail to: user.email
  end
end
