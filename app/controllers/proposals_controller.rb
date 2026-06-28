class ProposalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_job

  def new
    @proposal = @job.proposals.build
    authorize @proposal
  end

  def create
    @proposal = @job.proposals.build(proposal_params)
    @proposal.profile = current_user.profile
    authorize @proposal
    if @proposal.save
      redirect_to @job, notice: "Proposta enviada com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def accept
    @proposal = @job.proposals.find(params[:id])
    authorize @proposal
    @proposal.update!(status: "accepted")
    redirect_to @job, notice: "Proposta aceita."
  end

  def reject
    @proposal = @job.proposals.find(params[:id])
    authorize @proposal
    @proposal.update!(status: "rejected")
    redirect_to @job, notice: "Proposta recusada."
  end

  private

  def set_job
    @job = Job.find(params[:job_id])
  end

  def proposal_params
    params.require(:proposal).permit(:message, :value)
  end
end