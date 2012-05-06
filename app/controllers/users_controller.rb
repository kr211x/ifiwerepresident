class UsersController < ApplicationController
  before_filter :authenticate_user!, :only => :password_reset
  before_filter :require_current_issue!, :only => :show

  def new
    @title = "Create a Issue"
    @user = User.new
    @issue = Issue.new
  end

  def create
    @user = User.new(params[:user])
    @user.password = params[:user][:password]
    if @user.save
      signin! @user, "Thanks for creating an account!"
    else
      try_login or render 'sessions/new'
    end
  end

  def create_with_issue
    @user = User.new(params[:user])
    @user.password = params[:user][:password]
    @issue = Issue.new

    if @user.valid? and @issue.valid?
      @user.save!
      @issue.save!
      @issue.add_owner(@user)
      signin! @user, "Thanks for creating an account!"
    else
      try_login or render :new
    end
  end

  def show
    @user = User.find(params[:id])
    raise CanCan::AccessDenied.new("Not authorized!", :view, User) unless @user.member_of?(current_issue)
    participations = @user.participations.owner
    @issues = Issue.where(:_id.in => participations.collect{|p| p.issue_id}).asc(:name)
  end

  def password_reset
    @user = current_user
    if @user.authenticate(params[:old_password])
      if params[:password] == params[:password_confirmation]
        @user.password = params[:password]
        if @user.save
          redirect_to account_profile_path, :notice => "Password updated!"
        else
          redirect_to account_profile_path, :notice => @user.errors.full_messages.join(" ")
        end
      else
        redirect_to account_profile_path, :notice => "New password didn't match confirmation"
      end
    else
      redirect_to account_profile_path, :notice => "Old password didn't match"
    end
  end

  protected

  def try_login
    if user = User.first(conditions: {email: @user.email}) and user.authenticate(params[:user][:password])
      signin! user
      true
    else
      false
    end
  end

end
