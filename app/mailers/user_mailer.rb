class UserMailer < ApplicationMailer
  def account_activation(user)
    @user = user
    
    # mailオブジェクトがこのメソッドの暗黙の戻り値
    mail to: user.email, subject: "Account activation"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    
    # mailオブジェクトがこのメソッドの暗黙の戻り値
    mail to: user.email, subject: "Password reset"
  end
end
