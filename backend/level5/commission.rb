class Commission
  attr_accessor :insurance_fee, :assistance_fee, :drivy_fee, :total_fee, :owner_part, :rental

  def initialize(rental)
    @rental = rental
    @insurance_fee = 0.3 * 0.5 * rental.price
    @assistance_fee = 100 * rental.get_rental_days
    @drivy_fee = (rental.price * 0.3) - (insurance_fee + assistance_fee)
    @total_fee = insurance_fee + assistance_fee + drivy_fee
    @owner_part = rental.price - total_fee
  end

end