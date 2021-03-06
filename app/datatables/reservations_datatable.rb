class ReservationsDatatable < PagesController
  include CommonMethods

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: reservations.size,
      iTotalDisplayRecords: reservations.total_entries,
      aaData: data
    }
  end

private
  def data
   reservations.map do |r|
     {
       "DT_RowClass" => "group",
       "0" => h(r.name),
       "1" => h(r.number_people),
       "2" => h(r.formatted_time),
       "3" => "<a class='btn btn-small edit-btn' r_id='#{r.id}'><i class='icon-pencil'></i></a>"+
              "<a class='btn btn-small delete-btn' data-confirm='Are you sure you want to delete this reservation?' r_id='#{r.id}'>"+
              "<i class='icon-trash'></i></a>"
     }
   end 
  end  

  def reservations
    @reservations ||= fetch_reservations
  end

  def fetch_reservations
    date = params[:date].blank? ? nil : params[:date]
    reservs = Reservation.for_today(sort_column, sort_direction, date)
    reservs = reservs.page(page).per_page(per_page)
    if params[:sSearch].present?
      reservs = reservs.where("name like :search or number_people like :search", search: "%#params[:sSearch]%")
    end
    reservs
  end
  
  def sort_column
    columns = %w[name number_people datetime]
    columns[params[:iSortCol_0].to_i]
  end
end
