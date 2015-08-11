
def initialize(view)
  @view = view
end

def as_json(options = {})
  {
    sEcho: params[:sEcho].to_i,
    iTotalRecords: SClass.count,
    iTotalDisplayRecords: SClass.total_entries,
    aaData: data
  }
end

private
def data
  SClass.map do |product|
    [
      h(product.Title)
    ]
  end
end

def fetch_products
  products = SClass.order("#{sort_column} #{sort_direction}")
  products = products.page(page).per_page(per_page)
  if params[:sSearch].present?
    products = products.where("name like :search or category like :search", search: "%#{params[:sSearch]}%")
  end
  products
end
