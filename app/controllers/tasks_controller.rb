class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :require_user_logged_in
  before_action :authenticate_user, only:[:show, :edit, :update, :destroy]
  
  include SessionsHelper
  
  def index
    @tasks = current_user.tasks
  end
  
  def show
  end
  
  def new
    @task = Task.new
  end
  
  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
    
    if  @task.save
      flash[:success] = 'Taskが正常に作成されました。'
      redirect_to @task
    else
      flash.now[:danger] ='Taskが作成されませんでした。'
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @task.update(task_params)
      flash[:success] = 'Taskは正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Taskは更新されませんでした'
      render :edit
    end
  end
  
  def destroy
    @task.destroy
    
    flash[:success] = 'Taskは正常に削除されました'
    redirect_to tasks_url
  end
  
  private
  
  def set_task
    @task = Task.find(params[:id])
  end
  
  def task_params
    params.require(:task).permit(:content, :status)
  end
  
  def authenticate_user
    if current_user.id != @task.user_id
      redirect_to root_url
    end
  end
end
