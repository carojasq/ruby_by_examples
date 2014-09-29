class Monkey
	def initialize(name="Mico")
		@name = name
	end
	def printName
		puts  @name
	end 
	def name
		@name
	end
	def name= n
		@name = n
	end
	 
end

class Monkey
	def initialize(name="Mico")
		@name = name
	end
	attr_accessor :name #
end

m = Monkey.new()
m.name = "Gorila"
puts "The name of the monkey is #{m.name}"


