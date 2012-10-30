class Terminal

  # create implicit getters/setters in the class for 
  # base_prices and volume_prices
  attr_accessor :base_prices, :volume_prices, :subtotal

  def initialize(base_prices, volume_prices)
    @base_prices = base_prices
    @volume_prices = volume_prices
    @shopping_cart = Hash.new
    @subtotal = 0
  end

  def scan code 
    # look up code in base_price hash
    if @base_prices.include? code
      add_to_shopping_cart code
      apply_discounts code,@base_prices[code]
    end
  end
   
  
  def get_shopping_cart 
    @shopping_cart
  end
  #private

  def add_to_shopping_cart code
    if @shopping_cart.include? code
      @shopping_cart.merge!( code => @shopping_cart[code] +=1 )
    else
      @shopping_cart.merge!( {code => 1}) 
    end
    
  end
      
  def apply_discounts item,unit_price
    
    # just added new item to shopping cart, let's check to see
    # if this qualifies for any volume discounts
    
    if @volume_prices.include? item
      
      my_quantity = @shopping_cart[item] 
      vol_quantity = @volume_prices[item][:quantity]
      vol_price = @volume_prices[item][:price]
      
      if (my_quantity % vol_quantity == 0)
        #we've reached a volume discount
        
        @subtotal -= (my_quantity-1) * unit_price
        @subtotal += vol_price
        
        # the shopper needs to start accumulating 
        # for next volume discount
        @shopping_cart[item] = 0
      else
        @subtotal +=unit_price
      end
      
    else
      # no volume discounts defined for this item      
      @subtotal +=unit_price
    end
   
  end
  
end
