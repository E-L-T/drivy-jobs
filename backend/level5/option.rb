class Option
  attr_accessor :id, :rental_id, :type

  def initialize( rental_id, type)
    @rental_id = rental_id
    @type = type
  end
end