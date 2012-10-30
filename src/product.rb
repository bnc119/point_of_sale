class Product

  # create implicit getters/setters in the class for 
  # product code and base price 
  attr_accessor :code, :base_price  

  def initialize(code, base_price)
    @code = code
    @base_price = base_price
  end

end

