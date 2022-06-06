# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, except: %i[login new]
  before_action :find_user, only: %i[login]

  def new
    @user ||= User.new
  end

  def login
    if @user.persisted?
      if @user.authenticate(login_params[:password]) && @user.unlocked?
        session[:user_id] = @user.id
        redirect_to welcome_path and return
      else
        @user.increment_locked!
        @user.errors.add(:password, "attempt failed  #{@user.failed} times!!")
      end
    end
    @user.errors.add(:username, 'is invalid') if @user.new_record? && login_params[:username].present?
    render :new
  end

  def logout
    session.clear && (session[:user_id] = nil)
    session.delete(:user_id)
    redirect_to welcome_path
  end

  def welcome
    current_user
  end

  private

  def login_params
    params.require(:user).permit(:username, :password)
  end

  def find_user
    @user = User.find_by(username: login_params[:username]) || User.new
  end
end
