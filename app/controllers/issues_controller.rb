class IssuesController < ApplicationController
  before_filter :authenticate_user!, :except => :show

  def new
    @issue = Issue.new
  end

  def index
    @participations = current_user.participations.includes(:issue).where(:hidden => false).asc(:level)
  end

  def create
    @issue = Issue.new(params[:issue])
    if @issue.save
      #@issue.add_owner(current_user)
      redirect_to issues_path, :notice => "Issue created!"
    else
      render :new
    end
  end

  def show
    @issue = Issue.find(params[:id])
    redirect_to proposals_url @issue
  end

  def destroy
    @issue = Issue.find(params[:id])
    authorize! :destroy, @issue
    @issue.destroy
    redirect_to issues_path, :notice => "Issue deleted."
  end

end
