for i in (1..11)
	next if i==2
    #redo if 
	break if i==10
	puts "#{i}"
end

for i in ["uno", "dos", "tres"]
	puts "#{i}"
end
a = ["cuatro", "cinco", "seis"]

for element in a
	puts element.capitalize!
end

a = ["cuatro", "cinco", "seis"]
a.each do |i| i.capitalize! end
puts a
