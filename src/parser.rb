
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




