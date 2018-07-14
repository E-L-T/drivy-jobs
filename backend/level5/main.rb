require 'date'
require 'json'
require_relative 'car'
require_relative 'rental'
require_relative 'commission'
require_relative 'action'
require_relative 'option'

class OutFileGenerator
  
  def write
    output_json = JSON.pretty_generate({ "rentals": generate_output })
    out_file = File.new("data/output.json", "w")
    out_file.puts(output_json)
    out_file.close
  end
  
  private

  def generate_output
    input = JSON.parse(File.read("data/input.json"))
    output = Array.new()
    input['rentals'].each do |rental_input|
      rental = set_rental_from_input(rental_input)
      rental.price = get_rental_price_from_input(input, rental_input, rental)
      rental.commission = Commission.new(rental)
      rental = change_prices_if_options(input, rental)
      append_rental_output(rental_input, input, output, rental)
    end
    output
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

  def change_prices_if_options(input, rental)
    input['options'].each do |option_input|
      if option_input['rental_id'] == rental.id
        type = option_input['type']
        if type == 'additional_insurance'
          rental.commission.drivy_fee += 1000 * rental.get_rental_days
          rental.price += 1000 * rental.get_rental_days
        end
        if type == 'gps'
          rental.commission.owner_part += 500 * rental.get_rental_days
          rental.price += 500 * rental.get_rental_days
        end
        if type == 'baby_seat'
          rental.commission.owner_part += 200 * rental.get_rental_days
          rental.price += 200 * rental.get_rental_days
        end
      end
    end
    rental 
  end

  def append_rental_output(rental_input, input, output, rental)
    actions = []

    (1..5).each do |i|
      actions << { "who": '', "type": '', "amount": '' }
    end
    
    rental_output = { "id": '', "options": '', "actions": actions }
    rental_output[:options] = get_option_types_from_rental(input, rental)

    driver_action = Action.new(rental_input['id'], 'driver', 'debit', rental.price)
    set_rental_output(rental_output, driver_action, 0)
    
    owner_action = Action.new(rental_input['id'], 'owner', 'credit', rental.commission.owner_part)
    set_rental_output(rental_output, owner_action, 1)
    
    insurance_action = Action.new(rental_input['id'], 'insurance', 'credit', rental.commission.insurance_fee)
    set_rental_output(rental_output, insurance_action, 2)
    
    assistance_action = Action.new(rental_input['id'], 'assistance', 'credit', rental.commission.assistance_fee)
    set_rental_output(rental_output, assistance_action, 3)
    
    drivy_action = Action.new(rental_input['id'], 'drivy', 'credit', rental.commission.drivy_fee)
    set_rental_output(rental_output, drivy_action, 4)

    output << rental_output
  end

  def set_rental_output(rental_output, action, index)
    rental_output[:id] = action.rental_id
    rental_output[:actions][index][:who] = action.who
    rental_output[:actions][index][:type] = action.type
    rental_output[:actions][index][:amount] = action.amount
  end

  def get_option_types_from_rental(input, rental)
    option_types = []
    input['options'].each do |option_input|
      if option_input['rental_id'] == rental.id
        option_types << option_input['type']
      end
    end
    option_types 
  end
end

OutFileGenerator.new.write