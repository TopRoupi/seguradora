class InsuredsController < ApplicationController
  before_action :set_insured, only: %i[ show update destroy ]

  # GET /insureds
  def index
    @insureds = Insured.all

    render json: @insureds
  end

  # GET /insureds/1
  def show
    render json: @insured
  end

  # POST /insureds
  def create
    @insured = Insured.new(insured_params)

    if @insured.save
      render json: @insured, status: :created, location: @insured
    else
      render json: @insured.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /insureds/1
  def update
    if @insured.update(insured_params)
      render json: @insured
    else
      render json: @insured.errors, status: :unprocessable_entity
    end
  end

  # DELETE /insureds/1
  def destroy
    @insured.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_insured
      @insured = Insured.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def insured_params
      params.require(:insured).permit(:age, :dependents, :house_ownership_status, :married, :base_risk, :vehicle_year)
    end
end
