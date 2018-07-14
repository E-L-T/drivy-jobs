require 'date'
require 'json'
require_relative 'action'
require_relative 'commission'
require_relative 'rental'

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

  def set_commission(rental)
    commission = Commission.new
    commission.insurance_fee = 0.3 * 0.5 * rental.price
    commission.assistance_fee = 100 * rental.get_rental_days
    commission.drivy_fee = (rental.price * 0.3) - (commission.insurance_fee + commission.assistance_fee )
    commission.total = commission.insurance_fee + commission.assistance_fee + commission.drivy_fee
    commission
  end

  def append_rental_output(rental_input, output, rental)
    actions = []

    (1..5).each do |i|
      actions << { "who": '', "type": '', "amount": '' }
    end
    
    rental_output = { "id": "", "actions": actions }

    driver_action = Action.new(rental_input['id'], 'driver', 'debit', rental.price)
    set_rental_output(rental_output, driver_action, 0)
    
    owner_action = Action.new(rental_input['id'], 'owner', 'credit', rental.price - rental.commission.total)
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
end

OutFileGenerator.new.write