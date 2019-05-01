require 'json'
require_relative 'rental'
require_relative 'car'

class List
  def cars
    input["cars"].map do |car|
      Car.new(id: car["id"],
              price_per_day: car["price_per_day"],
              price_per_km: car["price_per_km"])
    end
  end

  def rentals
    input["rentals"].map do |rental|
      Rental.new(id: rental["id"],
                 car: select_car(rental["car_id"]),
                 start_date: rental["start_date"],
                 end_date: rental["end_date"],
                 distance: rental["distance"])
    end
  end

  def output
    { "rentals": rentals.map {|rental| {"id": rental.id, "price": rental.price }} }
  end

  def write
    json_output = JSON.pretty_generate(output)
    output_file = File.new("data/output.json", "w")
    output_file.puts(json_output)
    output_file.close
  end

  private

  def select_car rental_car_id
    cars.select {|car| car.id == rental_car_id}[0]
  end

  def input
    JSON.parse(File.read("data/input.json"))
  end
end
