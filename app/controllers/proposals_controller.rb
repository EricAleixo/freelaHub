class ProposalsController < ApplicationController
  before_action :set_proposal, only: %i[ show edit update destroy ]

  # GET /proposals or /proposals.json
  def index
    @proposals = Proposal.all
  end

  # GET /proposals/1 or /proposals/1.json
  def show
  end

  # GET /proposals/new
  def new
    @proposal = Proposal.new
  end

  # GET /proposals/1/edit
  def edit
  end

  # POST /proposals or /proposals.json
  def create
    @proposal = Proposal.new(proposal_params)

    respond_to do |format|
      if @proposal.save
        format.html { redirect_to @proposal, notice: "Proposal was successfully created." }
        format.json { render :show, status: :created, location: @proposal }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @proposal.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /proposals/1 or /proposals/1.json
  def update
    respond_to do |format|
      if @proposal.update(proposal_params)
        format.html { redirect_to @proposal, notice: "Proposal was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @proposal }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @proposal.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /proposals/1 or /proposals/1.json
  def destroy
    @proposal.destroy!

    respond_to do |format|
      format.html { redirect_to proposals_path, notice: "Proposal was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_proposal
      @proposal = Proposal.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def proposal_params
      params.require(:proposal).permit(:profile_id, :job_id, :message, :value, :status)
    end
end
