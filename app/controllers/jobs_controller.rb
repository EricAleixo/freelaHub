class JobsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_job, except: %i[index new create my_jobs]
  after_action :verify_authorized, except: %i[index my_jobs]

  def index
    profile_id = current_user.profile.id

    case_sql = Job.send(
      :sanitize_sql_array,
      ["MAX(CASE WHEN proposals.profile_id = ? THEN 1 ELSE 0 END)", profile_id]
    )

    @jobs = Job
      .where.not(user_id: current_user.id)
      .left_joins(:proposals)
      .select("jobs.*, #{case_sql} AS has_proposal")
      .group("jobs.id")
      .order("has_proposal ASC, jobs.created_at DESC")
  end

  def show
    authorize @job
  end

  def new
    @job = current_user.jobs.new(status: :draft)
    authorize @job
  end

  def create
    @job = current_user.jobs.new(job_params)
    authorize @job
    if @job.save
      redirect_to @job, notice: "Vaga publicada com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @job
  end

  def update
    authorize @job
    if @job.update(job_params)
      redirect_to @job, notice: "Vaga atualizada com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @job
    @job.destroy!
    redirect_to jobs_path, notice: "Vaga removida.", status: :see_other
  end

  def my_jobs
    @my_jobs = current_user.jobs.order(created_at: :desc)
    @my_proposals = Proposal.where(profile_id: current_user.profile.id) || []
  end

  private

  def set_job
    @job = Job.find(params[:id])
  end

  def job_params
    params.require(:job).permit(:title, :description, :budget, :status)
  end
end