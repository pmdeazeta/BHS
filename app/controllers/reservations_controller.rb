class ReservationsController < ApplicationController
  layout 'pages'
  before_filter :authenticate_user!
  
  def index
    @reservation = Reservation.new :datetime => DateTime.current
    get_reservations_count
    respond_to do |format|
      format.json { render json: PagesDatatable.new(view_context)}
      format.html
    end
  end

  def create
    @new_reservation = Reservation.new :datetime => DateTime.current
    @reservation = Reservation.new params[:reservation]
    params[:am_pm] == "AM" ? true : params[:hour] = params[:hour].to_i + 12
    @reservation.datetime = DateTime.current.change :hour => params[:hour].to_i, :min => params[:minutes].to_i, :sec => 0
    if @reservation.save
      flash[:notification] = "Reservation has been created successfully";
    end
    get_reservations_count
    respond_to do |format|
      format.js {render :layout => false}
    end
  end

  def edit 
    @reservation = Reservation.find params[:id]
    respond_to do |format|
      format.js {render :layout => false}
    end
  end

  def update
    update_reservation = Reservation.find params[:reservation][:id]
    params[:am_pm] == "AM" ? true : params[:hour] = params[:hour].to_i + 12
    update_reservation.datetime = DateTime.current.change :hour => params[:hour].to_i, :min => params[:minutes].to_i, :sec => 0
    if update_reservation.update_attributes params[:reservation]
      flash[:notification] = "Reservation has been successfully updated";
    end
    get_reservations_count
    respond_to do |format|
      format.js {render :layout => false}
    end
  end

  def destroy
    if Reservation.delete params[:id]
      flash[:notification] = "Reservation has been successfully deleted";
    end
    get_reservations_count
    respond_to do |format|
      format.js {render :layout => false}
    end
  end
  
  private
  def get_reservations_count
    @reservations = Reservation.for_today.count
  end
end
