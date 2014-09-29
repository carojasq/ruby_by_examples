def basic_structure(p1, p2)
	return nil
end

def imprime(p1, p2, p3="Nuevo")
	puts "#{p1} #{p2} #{p3}"
end

imprime "Hola","Mundo"
	
def di_hola(nombre, apellido)
	return "Hola, #{nombre} #{apellido}"  
end
puts di_hola "Henry", "Diosa"

def di_hola2(nombre, apellido="Perez")
	return "Hola, #{nombre} #{apellido}"  
end
puts di_hola2 "Natalia"
