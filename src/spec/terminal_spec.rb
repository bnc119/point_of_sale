require_relative'../terminal'

describe PointofSale::Terminal do

  describe "class" do
      
    before (:each) do 
      @terminal = PointofSale::Terminal.new
    end
     
    it "should be an instance of 'Terminal'" do
      @terminal.should be_an_instance_of PointofSale::Terminal
    end
    
    it "should respond to 'scan'" do
      @terminal.should respond_to(:scan)
    end
    
    it "should respond to 'add'" do
      @terminal.should respond_to(:add)
    end
    
    it "should respond to '+'" do
      @terminal.should respond_to(:+)
    end
    
    it "should respond to 'base_prices'" do
      @terminal.should respond_to(:base_prices)
    end
    
    it "should respond to 'volume_prices'" do
      @terminal.should respond_to(:volume_prices)
    end
    
    it "should respond to 'set_prices'" do
      @terminal.should respond_to(:set_prices)
    end
    
    it "should respond to 'total'" do
      @terminal.should respond_to(:total)
    end
    
    describe "input from hash" do
      before (:each) do
        
        base_prices = { "A" => 2.00, "B" => 12.00, "C" => 1.25,"D" => 0.15, "M" => 1.00}
        volume_prices = { "A" => {:quantity => 4, :price => 7.00},
                          "C" => {:quantity => 6, :price => 6.00} }                         
                                 
        @terminal.set_prices(base_prices, volume_prices)
            
      end
      
      it "should return correct # base_price items" do
        @terminal.base_prices.size.should == 5
      end
      
      it "should return correct # volume_price items" do
        @terminal.volume_prices.size.should == 2
      end
      
      it "should return the correct total from data set 1" do
        @terminal.scan "A"; @terminal.scan "B"; @terminal.scan "C"
        @terminal.scan "D"; @terminal.scan "A"; @terminal.scan "B"
        @terminal.scan "A"; @terminal.scan "A"
        
        @terminal.total.should == 32.40
       
      end
      
      it "should return the correct value 1 item of item A" do

        @terminal.scan "A"
        @terminal.total.should == 2.00
        
      end
      
      it "should return the correct value 1 item of item M" do
        
        @terminal.scan "M"
        @terminal.total.should == 1.00
        
      end
     
      
      it "should return the correct total from data set 2" do
        0.upto(6) { 
          @terminal.add "C"  
        }
        
        @terminal.total.should == 7.25
       
      end
      
      it "should return the correct total from data set 3" do
        @terminal + "A"; @terminal + "B"; @terminal + "C"
        @terminal + "D"
        
        @terminal.total.should == 15.40
       
      end
            
      it "should return 0 for blank/weird/unknown product codes" do
        @terminal.scan("Acme"); @terminal.scan("X");      @terminal.scan("Y");
        @terminal.scan("Z");    @terminal.scan("ZZ123");  @terminal.scan(""); 
        
        @terminal.total.should == 0.00
      end
      
      
      it "should be able to handle two independent transactions in a row" do
        for i in 0..6
          @terminal.scan "C"  
        end
        @terminal.total.should == 7.25
        
        @terminal.new_transaction
        
        @terminal.scan "A"; @terminal.scan "B"; @terminal.scan "C"
        @terminal.scan "D"
        @terminal.total.should == 15.40
       
      end
      
      it "should be able to process 1 million items" do
        for i in 0..999999
          @terminal.scan "A"  
        end
        
        # number of volume bundles at the volume price + 
        # number of units left over at the unit price
        @terminal.total.should == ((1000000 / @terminal.volume_prices["A"][:quantity] ) * 
                                  @terminal.volume_prices["A"][:price] ) +  
                                  ( 1000000 % @terminal.volume_prices["A"][:quantity] * 
                                  @terminal.base_prices["A"] )
        
      end
      
    end
    
    describe "input from file" do
      before (:each) do
        @terminal.set_prices("input_data/base_prices.txt", "input_data/volume_prices.txt")
      end
      
      it "should return correct # base_price items" do
        @terminal.base_prices.size.should == 4
      end
      
      it "should return correct # volume_price items" do
        @terminal.volume_prices.size.should == 2
      end
      
      it "should return the correct total after data set 1 is scanned" do
        @terminal.scan "A"; @terminal.scan "B"; @terminal.scan "C"
        @terminal.scan "D"; @terminal.scan "A"; @terminal.scan "B"
        @terminal.scan "A"; @terminal.scan "A"
        
        @terminal.total.should == 32.40
       
      end
      
      it "should return the correct total after data set 2 is scanned" do
        for i in 0..6
          @terminal.scan "C"  
        end
        
        @terminal.total.should == 7.25
       
      end
      
      it "should return the correct total after data set 3 is scanned" do
       @terminal.scan "A"; @terminal.scan "B"; @terminal.scan "C"
       @terminal.scan "D"
        
       @terminal.total.should == 15.40
       
      end
            
      it "should return nil on unknown items" do
        @terminal.scan("K").should == nil
      end
      
      
    end
   
  end
   
  
end



