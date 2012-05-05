class ProposalsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
  
  def new
    @proposal = Proposal.new(params[:proposal])
  end
  
  def create
    @issue = Issue.find(params[:issue_id])
    @proposal = Proposal.new(params[:proposal])
    @proposal.issue = @issue
    @proposal.user = current_user
    if @proposal.save      
      current_user.vote(@proposal, :up)
      @proposal.update_ranking
      redirect_to proposal_path(@issue, @proposal), :notice => "Proposal created!"
    else
      render :new
    end
  end
  
  def index
    @issue = Issue.find(params[:issue_id])
    if params[:search].present?
      @proposals = Proposal.solr_search do
        keywords params[:search]
        with :issue_id, current_issue.id
        paginate :page => params[:page]
      end
    else
      @proposals = @issue.proposals.with_tags(params[:tags], @issue).where(:'votes.point'.gt => -5).page(params[:page])
      
      if params[:sort] == 'top'
        @proposals = @proposals.desc('votes.point')
      elsif params[:sort] == 'latest'
        @proposals = @proposals.desc(:created_at)
      else
        @proposals = @proposals.desc(:ranking)
      end            
    end
  end
  
  def show
    @issue = Issue.find(params[:issue_id])
    @proposal = Proposal.find(params[:id])
    @comments = @proposal.comments
    @comment = Comment.new(params[:comment])
    if @proposal.nil?
      redirect_to root_path, :notice => "That proposal is no longer available."
      return
    end
    # @comment = @proposal.comments.new
    # @comments = @proposal.comments.asc(:lft).where(:'votes.point'.gt => -5).page(params[:page])
  end
  
  def edit
    @proposal = Proposal.find(params[:issue_id])
    authorize! :edit, @proposal
  end
  
  def update
    params[:proposal][:tag_ids] ||= []
    @proposal = current_issue.proposals.find(params[:id])
    authorize! :update, @proposal
    if @proposal.update_attributes(params[:proposal])
      redirect_to @proposal, :notice => "Proposal updated!"
    else
      render :edit
    end
  end
  
  def destroy
    @proposal = Proposal.find(params[:id])
    authorize! :destroy, @proposal
    @proposal.destroy
    redirect_to root_path, :notice => "Proposal deleted!"
  end
  
end
