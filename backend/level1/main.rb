require 'date'
require 'json'

class Car
  attr_accessor :price_per_day, :price_per_km

  def initialize(id, price_per_day, price_per_km)
    @price_per_day = price_per_day
    @price_per_km = price_per_km
  end
end

class Rental
  attr_accessor :start_date, :end_date, :distance

  def initialize(id, car_id, start_date, end_date, distance)
    @start_date = start_date
    @end_date = end_date
    @distance = distance
  end

  def calculates_time_component(price_per_day)
    rental_days = Date.parse(@end_date) - Date.parse(@start_date) + 1
    rental_days.to_int * price_per_day
  end

  def calculates_distance_component(price_per_km)
    @distance * price_per_km
  end

  def calculates_price_of_rental(price_per_day, price_per_km)
    calculates_time_component(price_per_day) + calculates_distance_component(price_per_km)
  end
end

class OutFileGenerator
  def generate_output
    input = JSON.parse(File.read("data/input.json"))
    output = Array.new()
    input['rentals'].each do |rental|
      rental_instance = set_rental_from_input(input, rental)
      price_of_rental = set_price_of_rental_from_input(input, rental, rental_instance)
      append_rental_output(rental, price_of_rental, output)
    end
    output
  end

  def write
    output = generate_output
    output_json = JSON.pretty_generate({ "rentals": output })
    out_file = File.new("data/output.json", "w")
    out_file.puts(output_json)
    out_file.close
  end

  private

  def set_rental_from_input(input, rental)
    id = rental['id']
    car_id = rental['car_id']
    start_date = rental['start_date']
    end_date = rental['end_date']
    distance = rental['distance']
    rental = Rental.new(id, car_id, start_date, end_date, distance)
  end

  def set_price_of_rental_from_input(input, rental, rental_instance)
    car_id = rental['car_id']
    price_per_day = input['cars'][car_id-1]['price_per_day']
    price_per_km = input['cars'][car_id-1]['price_per_km']
    price_of_rental = rental_instance.calculates_price_of_rental(price_per_day, price_per_km)
  end

  def append_rental_output(rental, price_of_rental, output)
    rental_output = { "id": '', "price": ''}
    id = rental['id']
    rental_output[:id] = id
    rental_output[:price] = price_of_rental
    output << rental_output
  end
end

instance_out_file = OutFileGenerator.new
instance_out_file.write