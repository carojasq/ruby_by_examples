class Persona
	define_method("generar_saludo_ingeniero") do |argumento|
			puts "Saludos Ingeniero #{argumento}"
	end
	define_method("generar_saludo_doctor") do |argumento|
			puts "Saludos Doctor #{argumento}"
	end
	define_method("generar_saludo_profesor") do |argumento|
			puts "Saludos Profesor #{argumento}"
	end
end
p = Persona.new
p.generar_saludo_profesor("Hernandez")
p.generar_saludo_doctor("Hernandez")



#Real power of define_method

class Persona
	["ingeniero", "doctor", "profesor"].each do |action|
		define_method("generar_saludo_#{action}") do |argumento|
			puts "Saludos #{action.upcase} #{argumento}"
		end
	end
end
p = Persona.new
p.generar_saludo_profesor("Hernandez")
p.generar_saludo_doctor("Hernandez")
