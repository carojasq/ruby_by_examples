
emails = ["CORREO_PRUEBA3423@GMAIL.COM", 
	"correo_no_v?lido@gmail.com", 
	"prueba_2@gmail.com.com"]

emails.each do |email|
	if email =~ /^[a-z0-9\_]+@[a-z0-9\_]+\.[a-z]+$/i
		puts "#{email} Valido"
	else 
		puts "#{email} No valido"
	end
end

