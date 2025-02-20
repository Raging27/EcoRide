class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin

  # PATCH /users/:id/suspend
  def suspend
    @user = User.find(params[:id])
    if @user.update(suspended: true)
      redirect_to dashboard_path, notice: "Utilisateur suspendu avec succès."
    else
      redirect_to dashboard_path, alert: "Erreur lors de la suspension de l'utilisateur."
    end
  end

  # DELETE /users/:id
  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      redirect_to dashboard_path, notice: "Utilisateur supprimé avec succès."
    else
      redirect_to dashboard_path, alert: "Erreur lors de la suppression de l'utilisateur."
    end
  end

  private

  def ensure_admin
    redirect_to root_path, alert: "Accès non autorisé." unless current_user.role == "admin"
  end
end
