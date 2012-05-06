class Account::SettingsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @issue = current_issue
    authorize! :edit, @issue
  end
  
  def update
    @issue = issue.find(params[:id])
    authorize! :update, @issue
    if @issue.update_attributes params[:issue]
      redirect_to account_settings_path, :notice => "Settings updated!"
    else
      render :index
    end
  end
end
