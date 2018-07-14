require "minitest/autorun"
require File.join(File.dirname(__FILE__), 'main')

describe "Drivy" do

  before do
    @car_id = 1
    @price_per_day = 2000
    @price_per_km = 10

    @rental_id = 1
    @car_id = 1
    @start_date = "2017-12-8"
    @end_date = "2017-12-8"
    @distance = 100
  end

  it "get a time component" do
    expected_time_component = 2000

    rental = Rental.new(@rental_id, @car_id, @start_date, @end_date, @distance)
    time_component = rental.get_time_component(@price_per_day)

    assert_equal(expected_time_component, time_component)
  end

  it "get a distance component" do
    expected_distance_component = 1000
    
    rental = Rental.new(@rental_id, @car_id, @start_date, @end_date, @distance)
    distance_component = rental.get_distance_component(@price_per_km)

    assert_equal(expected_distance_component, distance_component)
  end

  it "get rental price for 1 day of rental" do
    expected_rental_price = 3000
    
    rental = Rental.new(@rental_id, @car_id, @start_date, @end_date, @distance)
    rental_price = rental.get_rental_price(@price_per_day, @price_per_km)

    assert_equal(expected_rental_price, rental_price)
  end

  it "get rental price for 2 days of rental" do
    start_date = "2017/12/8"
    end_date = "2017/12/9"
    expected_rental_price = 4800
    
    rental = Rental.new(@rental_id, @car_id, start_date, end_date, @distance)
    rental_price = rental.get_rental_price(@price_per_day, @price_per_km)

    assert_equal(expected_rental_price, rental_price)
  end

  it "get rental price for 5 days of rental" do
    start_date = "2017/12/8"
    end_date = "2017/12/12"
    expected_rental_price = 9800
    
    rental = Rental.new(@rental_id, @car_id, start_date, end_date, @distance)
    rental_price = rental.get_rental_price(@price_per_day, @price_per_km)

    assert_equal(expected_rental_price, rental_price)
  end

  it "get rental price for 11 days of rental" do
    start_date = "2017/12/8"
    end_date = "2017/12/18"
    expected_rental_price = 17800
    
    rental = Rental.new(@rental_id, @car_id, start_date, end_date, @distance)
    rental_price = rental.get_rental_price(@price_per_day, @price_per_km)

    assert_equal(expected_rental_price, rental_price)
  end

  it "get the insurance_fee from the rental price" do
    expected_insurance_fee = 450
    
    rental = Rental.new(@rental_id, @car_id, @start_date, @end_date, @distance)
    rental_price = rental.get_rental_price(@price_per_day, @price_per_km)
    insurance_fee = rental_price * 0.5 * 0.3

    assert_equal(expected_insurance_fee, insurance_fee)
  end

  it "generates the expected output" do
    expected_output = JSON.parse(File.read("data/expected_output.json"))
    OutFileGenerator.new
    output = JSON.parse(File.read("data/output.json"))

    assert_equal(expected_output, output)
  end
end
