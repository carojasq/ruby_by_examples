class Monk
	["life", "universe", "everything"].each do |what|
		define_method("meditate_on_#{what}") do 
			puts "I know the meaning of #{what}"
		end
	end
end
m  = Monk.new
m.meditate_on_universe
m.meditate_on_everything