require 'date'
require 'json'

class Car
  attr_accessor :id, :price_per_day, :price_per_km

  def initialize args
    @id = args[:id]
    @price_per_day = args[:price_per_day]
    @price_per_km = args[:price_per_km]
  end
end

class Rental
  attr_accessor :id, :car, :start_date, :end_date, :distance, :price

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

  def period
    (Date.parse(@end_date) - Date.parse(@start_date) + 1).to_int
  end

  def distance_component
    @distance * @car.price_per_km
  end

  def price
    time_component + distance_component
  end
end

class List
  def cars
    input["cars"].map do |car|
      Car.new(id: car["id"], price_per_day: car["price_per_day"], price_per_km: car["price_per_km"])
    end
  end

  def rentals
    input["rentals"].map do |rental|
      Rental.new(id: rental["id"], car: select_car(rental["car_id"]), start_date: rental["start_date"], end_date: rental["end_date"], distance: rental["distance"])
    end
  end

  def output
    { "rentals": rentals.map {|rental| {"id": rental.id, "price": rental.price }} }
  end

  def write
    output_json = JSON.pretty_generate(output)
    out_file = File.new("data/output.json", "w")
    out_file.puts(output_json)
    out_file.close
  end

  private

  def select_car rental_car_id
    cars.select {|car| car.id == rental_car_id}[0]
  end

  def input
    JSON.parse(File.read("data/input.json"))
  end
end

list = List.new
list.write