class ParkingsController < ApplicationController

  # step 1: start parking, show form on start_parking
  def new
    @parking = Parking.new
  end

  # step 2: create a parking, record start_at
  def create
    @parking = Parking.new(parking_type: "guest", start_at: Time.now)
    @parking.save!
    redirect_to parking_path(@parking)
  end

  # step 4: end parking, record end_at
  def update
    @parking = Parking.find(params[:id])
    @parking.end_at = Time.now
    @parking.calculate_amount

    @parking.save!

    redirect_to parking_path(@parking)
  end

  # step 5: show amount
  def show
    @parking = Parking.find(params[:id])
  end

end
