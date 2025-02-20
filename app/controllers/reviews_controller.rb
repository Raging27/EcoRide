class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_trip

  def new
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    # Set the foreign key fields manually
    @review.trip_id = @trip.id
    @review.passenger_id = current_user.id
    @review.driver_id = @trip.driver_id

    if @review.save
      redirect_to trip_path(@trip), notice: "Avis soumis avec succès, en attente de validation."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_trip
    @trip = Trip.find(params[:trip_id])
  end

  def review_params
    params.require(:review).permit(:rating, :content)
  end
end
