def Skew(in_seq)
	skews = [0]
	(0..in_seq.length-1).each do |i|
		if in_seq[i]=="C"
			skews << skews.last-1
		elsif in_seq[i]=="G"
			skews << skews.last+1
		else
			skews << skews.last
		end
	end
	return skews
end

def MinSkews(in_seq)
	skews = Skew(in_seq)
	min = skews.min
	return skews.each_index.select{|i| skews[i]==min}
end

def MaxSkews(in_seq)
	skews = Skew(in_seq)
	puts skews.join " "
	max = skews.max
	return skews.each_index.select{|i| skews[i]==max}
end


puts MaxSkews("GATACACTTCCCAGTAGGTACTG").join " "
#MinSkews
#in_seq = gets.chomp	
#puts MinSkews(in_seq).join(" ")


#Skew input
#puts Skew("GAGCCACCGCGATA").join " "
