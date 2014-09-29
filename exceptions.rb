x = 5
y = 0
begin
	d = x/y
	puts "Result #{d}"
rescue
	puts "A exception has ocurred"
	puts "Retrying"
	y += 1
	retry
end


begin # Similar al try de java
	# Acá va el bloque de codigo
rescue # Similar al catch 
	# Acá va qué hacer en caso de Excepcion
	retry #Intentar volver a correr desde begin
end # Fin de la excepcion