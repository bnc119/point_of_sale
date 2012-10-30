require 'spec_helper'

describe Terminal do

  describe "Basic Terminal class instantiation and operations" do
      
    before (:each) do 
      base_prices = []
      volume_prices = []
      @terminal = Terminal.new(base_prices,volume_prices)
    end
     
    it "should be an instance of the correct class" do
      @terminal.should be_an_instance_of Terminal
    end
    
    it "should respond to scan" do
      @terminal.should respond_to(:scan)
    end
    
    it "should respond to base_prices" do
      @terminal.should respond_to(:base_prices)
    end
    
    it "should respond to volume_prices" do
      @terminal.should respond_to(:volume_prices)
    end
    
    describe "Processing of pricing data" do
      before (:each) do
      
        @terminal.base_prices = { "A" => 2.00, 
                                  "B" => 12.00, 
                                  "C" => 1.25,
                                  "D" => 0.15}
                                  
                                 
        @terminal.volume_prices = { "A" => {:quantity => 4, :price => 7.00},
                                    "C" => {:quantity => 6, :price => 6.00} 
                                  }
               
       
            
      end
      
      it "should return the correct # items in basic_pricing plan" do
        @terminal.base_prices.size.should == 4
      end
      
      it "should return the correct subtotal after data set 1 is scanned" do
        @terminal.scan "A"
        @terminal.scan "B"
        @terminal.scan "C"
        @terminal.scan "D"
        @terminal.scan "A"
        @terminal.scan "B"
        @terminal.scan "A"
        @terminal.scan "A"
        @terminal.subtotal.should == 32.40
       
      end
      
      it "should return the correct subtotal after data set 2 is scanned" do
        @terminal.scan "C"
        @terminal.scan "C"
        @terminal.scan "C"
        @terminal.scan "C"
        @terminal.scan "C"
        @terminal.scan "C"
        @terminal.scan "C"
        @terminal.subtotal.should == 7.25
       
      end
      
      it "should return the correct subtotal after data set 3 is scanned" do
        @terminal.scan "A"
        @terminal.scan "B"
        @terminal.scan "C"
        @terminal.scan "D"
        @terminal.subtotal.should == 15.40
       
      end
            
      it "should return nil on unknown items" do
        @terminal.scan("K").should == nil
      end
      
      
    end
    
    describe "Shopping cart" do
      it "should track items" do
        
        @terminal.add_to_shopping_cart "A"
        @terminal.get_shopping_cart.size.should == 1
        @terminal.get_shopping_cart["A"].should == 1
        
        @terminal.add_to_shopping_cart "A"
        @terminal.add_to_shopping_cart "A"
        
        @terminal.get_shopping_cart["A"].should == 3
      end
    end

  end
  

    
    
  
end



