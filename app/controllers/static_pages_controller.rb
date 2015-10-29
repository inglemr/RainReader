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

  def refresh_classlist_action
    SClass.getAllClasses()
    flash[:success] = "Classes Refreshed"
    redirect_to class_list_path

  end

   def delete_action
    SClass.deleteAll()
    flash[:success] = "Classes Refreshed"
    redirect_to class_list_path

  end

  def class_list
    respond_to do |format|
    format.html
    format.json { render json: SClassDatatable.new(view_context) }
  end
  end
end
