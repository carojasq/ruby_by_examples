
x=2
x*=2 while x.class.to_s!="Bignum"
bits = Math.log(x, 2)
puts "Bignum es desde 2^#{bits}"
t = 0
while t < 5
	puts "t es: #{t}"
	t += 1
	if t==3
		break
	end
end