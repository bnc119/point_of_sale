Bence Magyar
Oct 31, 2012
https://github.com/bnc119/point_of_sale
-------------------------------------------------------------

Welcome to the Point of Sale Application!

My Point-of-Sale (POS) coding exercise is written in Ruby.  It consists of one main class:  The Terminal class.
Aside from the constructor, the Terminal class exposes three main public methods:

set_prices(base_prices, volume_prices)
scan(code)
new_transaction


set_prices
-------------------------------------------------------------
The set_prices method allows clients to set both the unit_price (base_price) for n product codes, as well 
as the sale prices (volume_prices) for n product codes.  For convenience, set_prices will accept this information
in two different formats:  Either argument can be a 1) Hash or 2) String object that points to an input file.
The two arguments need not be the same type.  For example, base_prices could be a Hash and volume_prices
could be a String pointer to a file.

If a Hash is passed for base_prices, the Terminal class expects the following format:  

{ code1 => unit_price, code2 => unit_price }

For example, if we wanted to express that the unit price of product "A" = $.50 and that the unit price of 
product "B" = $1, we would pass the following Hash:  { "A" => 0.50, "B" => 1.00 }

If a Hash is passed for volume_prices, the Terminal class expects the following nested format:

{ code1 => {:quantity => q, :price => p } }
For example, if we wanted to express that the volume discount for product "A" = 4/$1.00, we would pass 
the following Hash:  { "A" => {:quanity => 4, :price => 1.00 } )


If a String pointer to a base_prices input file is passed, the string parser code parses each line of the file 
expecting the following format:

code,price

For example, if we wanted to express that the unit price of product "A" = $.50 and that the unit price of 
product "B" = $1, the contents of our input file would be: 

A,0.50
B,1.00

On the other hand, if a String pointer to a volume_prices input file is passed, the string parser code parses each line of the file 
expecting the following format:

code,quanity,price

For example, if we wanted to express that the volume discount for product "A" = 4/$1.00, the contents of our
input file would be: 

A,4,1.00

Note:  If an input file lists the same product code twice, the *last* instance of the product code "sticks".
For example, an input file of:

A,4,1.00
J,2,5.50
A,4,0.75

Yields a volume_price of 4 for $0.75 for item "A", since it appears last.

scan
-------------------------------------------------------------

Once the unit and promotional prices have been "entered", we're ready to start scanning items!
In order to accurately simulate a real POS terminal similiar to what you would find in a grocery store, 
we iteratively check for volume discounts after each item is scanned.  If the last item scanned into the 
"shopping_cart" meets the quantity threshold needed to earn the volume discount, the discount is applied 
immediately and applied to the "sub-total".  An alternative approach would have been to scan *all* items 
first, then start computing the final total, but then the customer would not be able to see their 
discounts accumulate in 'real-time' as their shopping cart is scanned.

With this approach, the code keeps a 'running total' of the transaction, from the first item to the last.


Testing with RSpec
-------------------------------------------------------------

Unit testing code with Rspec is a joy.  The Terminal class was developed using "Test-Driven Development" (TDD).
Most of the tests were written before any actual development on the Terminal class began.  Naturally, the
tests failed at first.  Then, as the implementation of the Terminal class was filled in, the tests began to pass.
The following conditions (scenarios) are tested:

Terminal class responds to all the correct method names and instance variables
Terminal class accepts pricing information from a hash
Terminal class returns the correct total for data set 1
Terminal class returns the correct total for data set 2
Terminal class returns the correct total for data set 3
Terminal class handles blank/weird/unknown product codes
Terminal class handles two independent transactions in a row
Terminal class returns the correct total for 1 million items
Terminal class accepts pricing information from an input file
Terminal class returns the correct total for data set 1
Terminal class returns the correct total for data set 2
Terminal class returns the correct total for data set 3

In total, there are 20 test cases.  The tests can be executed with:

bence@cognition:~/src/point_of_sale/src$ rspec spec/

...........Sorry, unable to find product Acme.  I'll remove that from your shopping cart
Sorry, unable to find product X.  I'll remove that from your shopping cart
Sorry, unable to find product Y.  I'll remove that from your shopping cart
Sorry, unable to find product Z.  I'll remove that from your shopping cart
Sorry, unable to find product ZZ123.  I'll remove that from your shopping cart
Sorry, unable to find product .  I'll remove that from your shopping cart
........Sorry, unable to find product K.  I'll remove that from your shopping cart
.

Finished in 5.21 seconds
20 examples, 0 failures



Runtime Complexity
-------------------------------------------------------------

For each of n items scanned:
  Unit Price hash lookup: O(1)
  Increment Shopping Cart quantity: O(1)
  Volume Price hash lookup: O(1)
  Shopping cart quantity hash lookup: O(1)
  Math to compute discounts and total price: O(1)
=
O(n) runtime complexity


Extra:  Idea for scaling this project to larger data sets
-------------------------------------------------------------

This problem seems ripe for a MapReduce algorithm running on top of HDFS.  An enormous shopping list 
could be loaded into HDFS.  The NameNode would break the file up into equal size blocks and replicate
them across the DataNodes in your cluster.  The MapReduce JobTracker then assigns a set of blocks to each
Mapper process.  In parallel, the Mappers read data from their assigned blocks, and produce an intermediate 
{key, value} pair that might look like:  

"A", 1
"B", 1
"C", 1

All intermediate key/value sets then get pushed through a sorter, such that each Reducer process in the cluster
is assigned a data set grouped by the same intermediate key k.  For example, Reducer process "X" might 
get assigned all products with code "B".  In parallel, each Reducer works on computing the quantity of their 
assigned product codes and computing a sub-total with all volume discounts included.  The sub-totals could then
be summed to find the grand total of the shopping cart.


