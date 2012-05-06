class VotesController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    redirect_to root_path, :notice => "You'll need to enable javascript to vote"
  end
  
  def create
    voteable = params[:issue_id].to_model
    allowed = true
    
    if current_user.over_rate_limit?
      allowed = false
      @error = "You are voting too fast.  Please wait a bit."
    end
    
    if voteable.respond_to?(:issue) and current_user.banned_from?(voteable.issue)
      allowed = false
    end
    
    if allowed
      if params[:toggle] == 'on'
        current_user.vote(voteable, params[:direction].to_sym)
      elsif params[:toggle] == 'off'
        current_user.unvote(voteable)
      end
      voteable.update_ranking
    end
  end
end
