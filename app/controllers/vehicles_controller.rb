class VehiclesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_driver!

  def index
    @vehicles = current_user.vehicles
  end

  def new
    @vehicle = Vehicle.new
  end

  def create
    @vehicle = current_user.vehicles.build(vehicle_params)
    if @vehicle.save
      redirect_to vehicles_path, notice: "Vehicle successfully added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def vehicle_params
    params.require(:vehicle).permit(:plate_number, :date_first_registration, :brand, :model, :color, :electric)
  end

  # Ensure that the current user is a driver.
  def ensure_driver!
    unless current_user.role == "driver" || current_user.role == "both"
      redirect_to root_path, alert: "Only drivers can manage vehicles."
    end
  end
end
