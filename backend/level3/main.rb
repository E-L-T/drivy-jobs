require 'date'
require 'json'

class Rental
  attr_accessor :id, :car_id, :start_date, :end_date, :distance, :price, :commission

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

class OutFileGenerator
  def generate_output
    input = JSON.parse(File.read("data/input.json"))
    output = Array.new()
    input['rentals'].each do |rental_input|
      rental = set_rental_from_input(rental_input)
      rental.price = get_rental_price_from_input(input, rental_input, rental)
      rental.commission = set_commission(rental)
      append_rental_output(rental_input, output, rental)
    end
    output
  end

  def write
    output_json = JSON.pretty_generate({ "rentals": generate_output })
    out_file = File.new("data/output.json", "w")
    out_file.puts(output_json)
    out_file.close
  end

  private

  def set_commission(rental)
    commission = Commission.new
    commission.insurance_fee = 0.3 * 0.5 * rental.price
    commission.assistance_fee = 100 * rental.get_rental_days
    commission.drivy_fee = (rental.price * 0.3) - (commission.insurance_fee + commission.assistance_fee )
    commission
  end

  def set_rental_from_input(rental_input)
    id = rental_input['id']
    car_id = rental_input['car_id']
    start_date = rental_input['start_date']
    end_date = rental_input['end_date']
    distance = rental_input['distance']
    rental = Rental.new(id, car_id, start_date, end_date, distance)
  end

  def get_rental_price_from_input(input, rental_input, rental)
    car_id = rental_input['car_id']
    price_per_day = input['cars'][car_id-1]['price_per_day']
    price_per_km = input['cars'][car_id-1]['price_per_km']
    rental_price = rental.get_rental_price(price_per_day, price_per_km)
  end

  def append_rental_output(rental_input, output, rental)
    rental_output = { "id": '', "price": '', "commission": { "insurance_fee": '', "assistance_fee": '' } }
    rental_output[:id] = rental_input['id']
    rental_output[:price] = rental.price
    rental_output[:commission] [:insurance_fee] = rental.commission.insurance_fee
    rental_output[:commission] [:assistance_fee] = rental.commission.assistance_fee
    rental_output[:commission] [:drivy_fee] = rental.commission.drivy_fee
    output << rental_output
  end
end

class Commission
  attr_accessor :insurance_fee, :assistance_fee, :drivy_fee
end

class Action
  attr_accessor :rental_id, :who, :type, :amount

  def initialize(rental_id, who, type, amount)
  end
end

OutFileGenerator.new.write