require 'date'

class Rental
  attr_accessor :id, :price

  def initialize args
    @id = args[:id]
    @car = args[:car]
    @start_date = args[:start_date]
    @end_date = args[:end_date]
    @distance = args[:distance]
  end

  def time_component
    period * @car.price_per_day
  end

  def distance_component
    @distance * @car.price_per_km
  end

  def price
    time_component + distance_component
  end

  private

  def period
    (Date.parse(@end_date) - Date.parse(@start_date) + 1).to_int
  end
end
