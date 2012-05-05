class ProconsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_params
  
  def load_params
    @proposal = Proposal.find(params[:proposal_id])
    @procons = @proposal.procons.find(params[:id]) if params[:id].present?
  end
  
  def create
    @issue = Issue.find(params[:issue_id])
    @procon = @proposal.procons.new(params[:procon])
    @procon.issue = @issue
    @procon.user = current_user
    @procon.parent = @proposal.procons.find(params[:procon][:parent_id]) unless params[:procon][:parent_id].blank?
    respond_to do |format|
      format.html do
        if @procon.save
          redirect_to proposal_path(@issue, @proposal), :notice => "procon proposaled!"
        else
          redirect_to proposal_path(@procon.proposal)
        end
      end
      format.js
    end
  end
  
  def update
    authorize! :update, @procon
    if @procon.update_attributes(params[:procon])
      redirect_to proposal_path(@proposal), :notice => "Updated!"
    else
      render :edit
    end
  end
  
  def edit
    authorize! :edit, @procon
  end
  
  def destroy
    if @procon.children.empty? or current_user.admin_of?(@procon.forum)
      @procon.destroy
    else
      @procon.update_attribute :deleted, true
    end
    redirect_to @proposal, :notice => "#{current_forum.procon_label} deleted"
  end
end
