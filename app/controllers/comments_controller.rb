class CommentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_params
  
  def load_params
    @proposal = current_forum.proposals.find(params[:proposal_id])
    @comment = @proposal.comments.find(params[:id]) if params[:id].present?
  end
  
  def create
    @comment = @proposal.comments.new(params[:comment])
    @comment.forum = current_forum
    @comment.user = current_user
    @comment.parent = @proposal.comments.find(params[:comment][:parent_id]) unless params[:comment][:parent_id].blank?
    
    respond_to do |format|
      format.html do
        if @comment.save
          redirect_to proposal_path(@comment.proposal), :notice => "Comment proposaled!"
        else
          redirect_to proposal_path(@comment.proposal)
        end
      end
      format.js
    end
  end
  
  def update
    authorize! :update, @comment
    if @comment.update_attributes(params[:comment])
      redirect_to proposal_path(@proposal), :notice => "Updated!"
    else
      render :edit
    end
  end
  
  def edit
    authorize! :edit, @comment
  end
  
  def destroy
    if @comment.children.empty? or current_user.admin_of?(@comment.forum)
      @comment.destroy
    else
      @comment.update_attribute :deleted, true
    end
    redirect_to @proposal, :notice => "#{current_forum.comment_label} deleted"
  end
end
