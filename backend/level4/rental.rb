class Rental
  attr_accessor :id, :car_id, :start_date, :end_date, :distance, :price, :commission, :actions

  def initialize(id, car_id, start_date, end_date, distance)
    @start_date = start_date
    @end_date = end_date
    @distance = distance
  end

  def get_rental_days
    (Date.parse(end_date) - Date.parse(start_date) + 1).to_int
  end

  def get_time_component(price_per_day)
    rental_days = get_rental_days
    if rental_days < 2
      return rental_days.to_int * price_per_day 
    elsif rental_days < 5
      return (((rental_days -1) * 0.9 * price_per_day) + price_per_day).to_int
    elsif rental_days < 11
      return (((rental_days -4) * 0.7 * price_per_day) + (3 * 0.9 * price_per_day) + price_per_day).to_int
    else
      return (((rental_days-10) * 0.5 * price_per_day) + (6 * 0.7 * price_per_day) + (3 * 0.9 * price_per_day) + price_per_day).to_int
    end
  end

  def get_distance_component(price_per_km)
    distance * price_per_km
  end

  def get_rental_price(price_per_day, price_per_km)
    get_time_component(price_per_day) + get_distance_component(price_per_km)
  end
end