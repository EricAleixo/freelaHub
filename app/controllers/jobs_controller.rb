class JobsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_job, only: %i[show edit update destroy]

  # GET /jobs
  def index
    @jobs = current_user.jobs.order(created_at: :desc)
  end

  # GET /jobs/1
  def show
  end

  # GET /jobs/new
  def new
    @job = current_user.jobs.new(status: :draft)
  end

  # GET /jobs/1/edit
  def edit
  end

  # POST /jobs
  def create
    @job = current_user.jobs.new(job_params)

    if @job.save
      redirect_to @job, notice: "Job was successfully posted."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /jobs/1
  def update
    if @job.update(job_params)
      redirect_to @job, notice: "Job was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /jobs/1
  def destroy
    @job.destroy!
    redirect_to jobs_path, notice: "Job was successfully removed.", status: :see_other
  end

  private

  # Sempre escopado ao usuário logado — impede acessar/editar job de outra pessoa
  # trocando o :id na URL.
  def set_job
    @job = current_user.jobs.find(params[:id])
  end

  def job_params
    params.require(:job).permit(:title, :description, :budget, :status)
  end
end