class StaticPagesController < ApplicationController
  def home
  end

  def help
  end

  def about
  end

  def refresh_action
    @user = User.find(params[:user_id])
    if @user == current_user
      getSchedule(current_user,true)
    end
    render 'home'
  end

  def class_list

  end


end
