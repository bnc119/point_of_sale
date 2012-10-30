require 'spec_helper'

describe Product do 

  describe "Basic Product class instantiation and operations" do 
    before(:each) do
      @product = Product.new("A", 0.25)
    end
    
    it "should be an instance of the correct class" do
      @product.should be_an_instance_of Product
    end
    
    it "should respond to code" do
      @product.should respond_to(:code)
    end
    
    it "should respond to base_price" do
      @product.should respond_to(:base_price)
    end
  
  end


end
