class VerificationsController < ApplicationController

  def index
    flash.delete(:notice)
    if current_user.nil?
      redirect_to signin_path, :notice => "Please sign in first."
      return
    end
    current_user.send_verification_email()
  end

  def create
    current_user.send_verification_email()
    redirect_to verifications_path, :notice => "Verification email sent!"
  end

  def show
    if params[:id].present? and user = User.where(:verification_token => params[:id]).first
      if !user.verified?
        user.verified_at = Time.zone.now
        user.save!
      end
      path = issue_path
      redirect_to path, :notice => "Your account has been verified!"
    else
      redirect_to verifications_path, :notice => "Couldn't find that verification code.  Please resend a new one."
    end
  end
end
