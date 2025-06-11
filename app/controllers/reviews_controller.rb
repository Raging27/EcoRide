class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_trip
  before_action :set_review, only: [:approve, :reject]
  before_action :authorize_employee, only: [:approve, :reject]

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

  def approve
    if @review.update(status: "approved")
      redirect_to dashboard_path, notice: "L'avis a été approuvé avec succès."
    else
      redirect_to dashboard_path, alert: "Erreur lors de l'approbation de l'avis."
    end
  end

  def reject
    if @review.update(status: "rejected")
      redirect_to dashboard_path, notice: "L'avis a été rejeté avec succès."
    else
      redirect_to dashboard_path, alert: "Erreur lors du rejet de l'avis."
    end
  end

  private

  def set_trip
    @trip = Trip.find(params[:trip_id])
  end

  def set_review
    @review = Review.find(params[:id])
  end

  def authorize_employee
    unless current_user.role == "employee"
      redirect_to dashboard_path, alert: "Vous n'êtes pas autorisé à effectuer cette action."
    end
  end

  def review_params
    params.require(:review).permit(:rating, :content)
  end
end
