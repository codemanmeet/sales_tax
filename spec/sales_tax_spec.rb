require 'sales_tax'

describe Product do
	it 'should have one product created' do
		@testProduct = Product.new(name: "Cadbury chocolate", price: 14.99, isImported: false, isExempted: true)
    expect(@testProduct.getName).to eq("Cadbury chocolate")
    expect(@testProduct.getPrice).to eq(14.99)
    expect(@testProduct.isExempted?).to be true
    expect(@testProduct.isImported?).to be false
	end
end

describe Cart do

	before do
		@testCart = Cart.new
		@casettes = Product.new(name: "box of casettes", price: 14.99, isImported: false, isExempted: false)
    @medicine = Product.new(name: "box of crocin medicine", price: 9.75, isImported: true, isExempted: false)
		@importedChocolates = Product.new(name: "imported box of chocolates", price: 10.00, isImported: true, isExempted: true)
		@importedPerfume = Product.new(name: "imported bottle of perfume", price: 27.99, isImported: true, isExempted: true)
		@localPerfume = Product.new(name: "brand new bottle of perfume", price: 18.99, isImported: false, isExempted: false)
	end

	it 'can add a product to the shopping cart' do
		@testCart.insert(@casettes, 1)
		expect(@testCart.getTotalTax).to eq(1.50)
	end

	it 'can add more than one product to the shopping cart' do
		@testCart.insert(@casettes, 1)
		@testCart.insert(@importedChocolates, 1)
		expect(@testCart.getTotalTax).to eq(2.0)
	end

	it 'can add multiple quantities of one product to the shopping cart' do
		@testCart.insert(@casettes, 4)
		@testCart.insert(@localPerfume, 2)
		expect(@testCart.getTotalTax).to eq(9.8)
	end

	it 'should print appropriately the entire product catalog' do
		@testCart2 = Cart.new
		@testCart2.insert(@importedPerfume, 1)
    @testCart2.insert(@medicine, 1)
		@testCart2.insert(@localPerfume, 1)
		@testCart2.insert(@importedChocolates, 1)
		expect(@testCart2.printItems).to eq("1, imported bottle of perfume, 29.39\n1, box of crocin medicine, 11.25\n1, brand new bottle of perfume, 20.89\n1, imported box of chocolates, 10.50\nSales Taxes: 5.30\nTotal: 72.03")
	end

end
