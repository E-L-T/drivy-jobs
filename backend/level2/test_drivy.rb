require "minitest/autorun"
require File.join(File.dirname(__FILE__), 'main')

describe "Drivy" do
  it "creates a car" do
    id = 1
    price_per_day = 2000
    price_per_km = 10

    expected_car = Car.new(id, price_per_day, price_per_km)

    assert_equal(expected_car.price_per_day, price_per_day)
    assert_equal(expected_car.price_per_km, price_per_km)
  end

  it "creates a rental" do
    id = 1
    car_id = 1
    start_date = "2017-12-8"
    end_date = "2017-12-10"
    distance = 100

    expected_rental = Rental.new(1, 1, start_date, end_date, distance)

    assert_equal(expected_rental.start_date, start_date)
    assert_equal(expected_rental.end_date, end_date)
    assert_equal(expected_rental.distance, distance)
  end

  it "creates a time component" do
    rental_days = 1
    car_price_per_day = 2000
    time_component = 2000
    
    expected_car = Car.new(1, 2000, 10)
    expected_rental = Rental.new(1, 1, "2017/12/8", "2017/12/8", 100)
    expected_time_component = expected_rental.calculates_time_component(car_price_per_day)

    assert_equal(expected_time_component, time_component)
  end

  it "creates a distance component" do
    distance = 100
    car_price_per_km = 10
    distance_component = 1000
    
    expected_car = Car.new(1, 2000, 10)
    expected_rental = Rental.new(1, 1, "2017/12/8", "2017/12/10", 100)
    expected_distance_component = expected_rental.calculates_distance_component(car_price_per_km)

    assert_equal(expected_distance_component, distance_component)
  end

  it "calculates rental price for 1 day of rental" do
    rental_days = 1
    car_price_per_day = 2000
    time_component = 2000
    distance = 100
    car_price_per_km = 10
    distance_component = 1000
    rental_price = 3000
    
    expected_car = Car.new(1, 2000, 10)
    expected_rental = Rental.new(1, 1, "2017/12/8", "2017/12/8", 100)
    expected_rental_price = expected_rental.calculates_price_of_rental(car_price_per_day, car_price_per_km)

    assert_equal(expected_rental_price, rental_price)
  end

  it "calculates rental price for 2 days of rental" do
    rental_days = 2
    car_price_per_day = 2000
    time_component = 3800
    distance = 100
    car_price_per_km = 10
    distance_component = 1000
    rental_price = 4800
    
    expected_car = Car.new(1, 2000, 10)
    expected_rental = Rental.new(1, 1, "2017/12/8", "2017/12/9", 100)
    expected_rental_price = expected_rental.calculates_price_of_rental(car_price_per_day, car_price_per_km)

    assert_equal(expected_rental_price, rental_price)
  end

  it "calculates rental price for 5 days of rental" do
    rental_days = 5
    car_price_per_day = 2000
    time_component = 8800
    distance = 100
    car_price_per_km = 10
    distance_component = 1000
    rental_price = 9800
    
    expected_car = Car.new(1, 2000, 10)
    expected_rental = Rental.new(1, 1, "2017/12/8", "2017/12/12", 100)
    expected_rental_price = expected_rental.calculates_price_of_rental(car_price_per_day, car_price_per_km)

    assert_equal(expected_rental_price, rental_price)
  end

  it "calculates rental price for 11 days of rental" do
    rental_days = 11
    car_price_per_day = 2000
    time_component = 16800
    distance = 100
    car_price_per_km = 10
    distance_component = 1000
    rental_price = 17800
    
    expected_car = Car.new(1, 2000, 10)
    expected_rental = Rental.new(1, 1, "2017/12/8", "2017/12/18", 100)
    expected_rental_price = expected_rental.calculates_price_of_rental(car_price_per_day, car_price_per_km)

    assert_equal(expected_rental_price, rental_price)
  end

  it "generates the expected output" do
    expected_output = JSON.parse(File.read("data/expected_output.json"))
    OutFileGenerator.new
    output = JSON.parse(File.read("data/output.json"))

    assert_equal(expected_output, output)
  end
end
