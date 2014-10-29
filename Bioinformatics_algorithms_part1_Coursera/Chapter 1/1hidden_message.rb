puts "Insert message"
a = gets.chomp
trans = {"8" => "E",
	";" => "T",
	"4" => "H",}
trans.each do |k, v|
    a.gsub! k,v
end
puts a
	 
