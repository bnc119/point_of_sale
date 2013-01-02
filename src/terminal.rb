class Terminal

  # create class instance variables with corresponding readers
  attr_reader :base_prices, :volume_prices, :total

  def initialize
    @shopping_cart = Hash.new
    @base_prices   = Hash.new
    @volume_prices = Hash.new
    @threshold_prices = Hash.new
    @total = 0.00
  end
     
  # set_prices either takes hashes in the following format:
  # base_prices = { "A" => 0.75, "M" => 1.00 }
  # volume_prices = { "A" => {:quantity => 4, :price => 1 } } 
  # threshold_prices = { "A" => {:quantity => 10, :price => 1 } }
  # Alternatively, a path to an input file can also be used.
  # See "parse_input_file" function for parsing assumptions
  
  def set_prices(base_prices, volume_prices, threshold_prices=nil)
    if base_prices.instance_of? Hash
      @base_prices=base_prices
    elsif base_prices.instance_of? String
      parse_input_file base_prices,"base"
    end
    
    if volume_prices.instance_of? Hash
      @volume_prices=volume_prices
    elsif volume_prices.instance_of? String
      parse_input_file volume_prices,"volume"
    end
    
    if threshold_prices.instance_of? Hash
      @threshold_prices=threshold_prices
    # TODO
    #elsif volume_prices.instance_of? String
    #  parse_input_file volume_prices,"volume"
    end
    
  end
  
  def scan code 
    # look up code in base_price hash
    if @base_prices.include? code
      add_to_shopping_cart code
      apply_discounts code,@base_prices[code]
    else
      puts "Sorry, unable to find product #{code}.  I'll remove that from your shopping cart"
    end
  end
  
  def new_transaction
    @total = 0.0
    @shopping_cart = {}
  end
   
  private

  def add_to_shopping_cart code
    if @shopping_cart.include? code
      @shopping_cart.merge!( code => @shopping_cart[code] +=1 )
    else
      @shopping_cart.merge!( {code => 1}) 
    end
  end
      
  def apply_discounts item,unit_price
    
    
    if (@threshold_prices.include? item)
	    
	    my_quantity = @shopping_cart[item] 
      thresh_quantity = @threshold_prices[item][:quantity]
      thresh_price = @threshold_prices[item][:price]
    
      if (my_quantity >= thresh_quantity)
       @total -= (my_quantity-1) * unit_price
       @total += thresh_price
        
       # the shopper needs to start accumulating this item 
       # for next thresh_price discount
       @shopping_cart[item] = 0
      else
        @total +=unit_price
      end
      
    elsif (@volume_prices.include? item)
      
      
      my_quantity = @shopping_cart[item] 
      vol_quantity = @volume_prices[item][:quantity]
      vol_price = @volume_prices[item][:price]
      
      if (my_quantity % vol_quantity == 0)
        #we've reached a volume discount
        
        @total -= (my_quantity-1) * unit_price
        @total += vol_price
        
        # the shopper needs to start accumulating this item 
        # for next volume discount
        @shopping_cart[item] = 0
      else
        @total +=unit_price
      end
      
    else
      # no volume OR threshold discounts available  for this item      
      @total +=unit_price
    end
    
   
  end
  
  # Input files are assumed to have the following syntax.  
  # For type = base_prices:    (Product,unit_price)
  # A,0.75
  # B,1
  # For type = volume_prices:  (Product,quantity_threshold,price)
  # A,4,1
  
  def parse_input_file path, type
    begin
      ret = Hash.new
      file = File.new(path, "r")
      while (line = file.gets)
        arr=line.split(',')
          if type == "base"
            ret.merge!(arr[0] => arr[1].to_f)
            @base_prices = ret
          elsif
            ret.merge!(arr[0] => { :quantity => arr[1].to_f,:price=> arr[2].to_f } )
            @volume_prices = ret
          end
        end
        file.close
      end
    rescue => err
      puts "Sorry, cannot open file: #{path}"
  end
end




