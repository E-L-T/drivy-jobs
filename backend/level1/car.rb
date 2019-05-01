class Car
  attr_accessor :id, :price_per_day, :price_per_km

  def initialize args
    @id = args[:id]
    @price_per_day = args[:price_per_day]
    @price_per_km = args[:price_per_km]
  end
end