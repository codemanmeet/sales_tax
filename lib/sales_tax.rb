
TAX_RATES = {:basic_sales_tax => 0.1, :import_duty_tax => 0.05}.freeze

class Float
  def round_with_precision(precision)
    (self * 1/precision).round.to_f/(1/precision)
  end
end

class Product
	def initialize(name, price, isImported = false, isExempted = false)
		@name = name
		@price = price.to_f
    @isImported = isImported
		@isExempted = isExempted
	end

	def getName
		@name
	end

	def getPrice
		@price
	end

  def isImported?
    @isImported
  end

	def isExempted?
		@isExempted
	end
end

class Cart
	def initialize()
    @basic_sales_tax = TAX_RATES[:basic_sales_tax]
    @import_duty_tax = TAX_RATES[:import_duty_tax]
		@total_tax = 0
		@total_amount = 0
		@product_catalog = []
	end

	def insert(item, quantity)
		item_tax = ((calculateBasicSalesTax(item) + calculateImportTax(item))*quantity*1.0).round_with_precision(0.05)
		@total_tax = @total_tax + item_tax
		taxed_item = item.getPrice()*quantity + item_tax
		@total_amount = @total_amount + taxed_item
		@product_catalog << quantity.to_s + ", " + item.getName + ", " + ('%.2f' % taxed_item).to_s
	end

	def printReceipt()
		@product_catalog << ("Sales Taxes: " + ('%.2f' % @total_tax).to_s)
		@product_catalog << ("Total: " + ('%.2f' % @total_amount).to_s)
		@product_catalog.join("\n")
	end

  def calculateBasicSalesTax(item)
    if !item.isExempted?
      return (item.getPrice * @basic_sales_tax)
    end
    0
  end
  def calculateImportTax(item)
    if item.isImported?
      return (item.getPrice * @import_duty_tax)
    end
    0
  end
end


#Main Application

keywords = ["book", "chocolate", "pill", "food", "medicine", "novel"]
cart = Cart.new
f = File.open("input.txt", "r")
f.each_line do |line|
  line_arr = line.split(",").map(&:strip)
  quantity = line_arr[0]
  name = line_arr[1]
  price = line_arr[2]
	isImported = line.include?("imported")
	isExempted = keywords.any? {|word| line.include?(word)}

	item = Product.new(name, price, isImported, isExempted)
	cart.insert(item, quantity.to_i)
end
f.close

f = File.open("output.txt", "w")
f.write(cart.printReceipt)
f.close
