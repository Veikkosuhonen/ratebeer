class MembershipsController < ApplicationController
  before_action :set_membership, only: %i[show edit update destroy]
  before_action :ensure_that_signed_in, except: [:index, :show]

  # GET /memberships or /memberships.json
  def index
    @memberships = Membership.all
  end

  # GET /memberships/1 or /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
    user = current_user
    @beer_clubs = BeerClub.all.reject { |bc| bc.users.include? user }
  end

  # GET /memberships/1/edit
  def edit
  end

  # POST /memberships or /memberships.json
  def create
    @membership = Membership.new(membership_params)
    @membership.user = current_user
    respond_to do |format|
      if @membership.save
        format.html { redirect_to beer_club_url(@membership.beer_club), notice: "You have applied to #{@membership.beer_club}. Please wait until a member accepts you in." }
        format.json { render :show, status: :created, location: @membership }
      else
        user = current_user
        @beer_clubs = BeerClub.all.reject { |bc| bc.users.include? user }
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memberships/1 or /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to membership_url(@membership), notice: "Membership was successfully updated." }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1 or /memberships/1.json
  def destroy
    @membership.destroy

    respond_to do |format|
      format.html { redirect_to @membership.beer_club, notice: "Membership ended" }
      format.json { head :no_content }
    end
  end

  def confirm
    membership = Membership.find(params[:id])
    membership.is_confirmed = true
    membership.save

    redirect_to membership.beer_club, notice: "#{membership.user} accepted to #{membership.beer_club}"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_membership
    @membership = Membership.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def membership_params
    params.require(:membership).permit(:beerclub_id)
  end
end
