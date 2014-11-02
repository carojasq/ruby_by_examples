def HammingDistance(s1, s2)
	count = 0
	(0..s1.length).each do |i|
		count += 1 if s1[i] != s2[i]
	end
	return count
end


def ReverseComplement(in_seq)
	maps = {'A' => 'T', 'T' => 'A', 'C' => 'G', 'G' => 'C'}
	out_seq = ""
	in_seq.split("").each do |l|
		out_seq += maps[l]
	end
	return out_seq.reverse
end



def Suffix(pattern)
	return pattern.slice(1..pattern.length-1)
end



def NumbertoSymbol(n)
	symbols = ["A", "C", "G", "T"]
	return symbols[n]
end

def SymboltoNumber(s)
	symbols = ["A", "C", "G", "T"]
	return symbols.find_index(s)
end


def PatternToInteger(pattern)
	if pattern == ""
		return 0
	end
	s = pattern[-1]
	pattern[-1]=""
	return (4 * PatternToInteger(pattern)) + SymboltoNumber(s)
	#return ["A", "C", "G", "T"].repeated_permutation(pattern.length).find_index(pattern.split(""))
end

def IntegerToPattern(integer, k)
	if k==1
		return NumbertoSymbol(integer)
	end
	prefix_index = integer / 4
	r = integer % 4
	prefix_pattern = IntegerToPattern(prefix_index, k-1)
	s = NumbertoSymbol(r)
	return prefix_pattern+s
	#return ["A", "C", "G", "T"].repeated_permutation(pattern_length).take(integer+1).last.join("")
end

def InmediateNeighbors(pattern)
	neighborhood = [pattern]
	nucleotides = ["A", "C", "G", "T"]
	pl = pattern.length
	(1..pattern.length).each do |i|
		s = pattern[i-1]
		(nucleotides-[s]).each do |n|
			begin
				#puts "First part '#{pattern.slice(0,i-1)}', then '#{n}', finishing with '#{pattern.slice(i-1, pl-i)}'"
			    new_pattern = pattern.slice(0,i-1)+n+pattern.slice(i-1, pl-i)
			rescue
				new_pattern = pattern.slice(0,i-1).join("")+n+pattern.slice(i-1, pl-i).join("")
			end
			#puts new_pattern
			neighborhood.push(new_pattern)
			#puts "Replacing #{s} with #{n} in position #{i}"
			#puts "Neighborhood #{neighborhood}"
		end
	end	
	return neighborhood
end

def Neighbors(pattern, d)
	nucleotides = ["A", "C", "G", "T"]
	if d==0
		return [pattern]
	end
	if pattern.length == 1
		return nucleotides
	end
	neighborhood = []
	suffix_neighboors  = Neighbors(Suffix(pattern), d)
	suffix_neighboors.each do |s|
		if HammingDistance(Suffix(pattern), s) < d
			nucleotides.each do |n|
				neighborhood<< n+s
			end
		else
			neighborhood << pattern[0] + s
		end
	end
	return neighborhood
end


def IterativeNeighbors(pattern, d)
	neighborhood = [pattern]
	(1..d).each do |j|
		neighborhood.each  do |p| 
			neighborhood += InmediateNeighbors(p)
			neighborhood.uniq!
		end
	end
	return neighborhood
end


def ApproximatePatternCount(text, pattern, d)
	count = 0 
	(0..(text.length-pattern.length)).each do |i|
		count += 1 if HammingDistance(pattern, text.slice(i, pattern.length)) <= d
	end
	return count
end

def ApproximatePatternMatch(text, pattern, d)
	match_index = []
	(0..(text.length-pattern.length)).each do |i|
		p1 = text.slice(i, pattern.length)
		match_index.push(i) if HammingDistance(pattern, p1) <= d
	end
	return match_index
end


def FrequentWordsWithMismatches(text, k, d)
	frequent_patterns = []
	close = []
	frequency_array = []
	puts "Initializing array"
	(0..(4**k)-1).each do |i|
		close[i] = 0
		frequency_array[i] = 0
	end
	puts "Generating neighborhood"
	(0..text.length-k).each do |i|
		neighborhood = IterativeNeighbors(text.slice(i,k), d)
		puts "This neighborhood measures #{neighborhood.length}, current position #{i.to_s}"

		neighborhood.each do |p|
			index = PatternToInteger(p)
			close[index] = 1
		end
    end
    puts "Aproximate pattern counting"
    (0..(4**k)-1).each do |i|
    	if close[i]==1
    		pattern = IntegerToPattern(i, k)
    		aprox_count =  ApproximatePatternCount(text, pattern, d)
    		#puts "#{aprox_count}, #{text}, #{pattern}"
    		frequency_array[i]= aprox_count
    	end
    end
    maxcount = frequency_array.max
    puts "Selecting patterns with max count #{maxcount}"
    indices = frequency_array.each_index.select{|i| frequency_array[i]==maxcount}

    #puts "Here are the indices #{indices.join ' '}"
    indices.each do |i|
    	frequent_patterns << IntegerToPattern(i, k)
    end
    return frequent_patterns
end


def FrequentWordsWithMismatchesandReverseComplement(text, k, d)
	frequent_patterns = []
	close = []
	frequency_array = []
	puts "Initializing array"
	(0..(4**k)-1).each do |i|
		close[i] = 0
		frequency_array[i] = 0
	end
	puts "Generating neighborhood"
	(0..text.length-k).each do |i|
		neighborhood = IterativeNeighbors(text.slice(i,k), d)
		puts "This neighborhood measures #{neighborhood.length}, current position #{i.to_s}"
		neighborhood.each do |p|
			index = PatternToInteger(p)
			close[index] = 1
		end
    end
    puts "Counting Aproximate patterns with reverse "
    (0..(4**k)-1).each do |i|
    	if close[i]==1
    		pattern = IntegerToPattern(i, k)
    		aprox_count =  ApproximatePatternCount(text, pattern, d) + ApproximatePatternCount(text, ReverseComplement(pattern), d)
    		#Countd(Text, Pattern)+ Countd(Text, Pattern)
    		#puts "#{aprox_count}, #{text}, #{pattern}"
    		frequency_array[i]= aprox_count
    	end
    end
    maxcount = frequency_array.max
    puts "Selecting patterns with max count #{maxcount}"
    indices = frequency_array.each_index.select{|i| frequency_array[i]==maxcount}

    #puts "Here are the indices #{indices.join ' '}"
    indices.each do |i|
    	frequent_patterns << IntegerToPattern(i, k)
    end
    return frequent_patterns
end


#FrequentWordsWithMismatches
in_seq1 = gets.chomp
ps = gets.chomp
ps = ps.split(" ")
k = ps[0].to_i
d = ps[1].to_i
puts "Seq lenght = #{in_seq1.length}, #{k.to_s}k-mer, hamming distance = #{d} "
puts FrequentWordsWithMismatchesandReverseComplement(in_seq1, k,d).join " "


#puts IterativeNeighbors("CCCC", 3).join(" ")
#puts IterativeNeighbors("CCCC", 3).count()
#puts ApproximatePatternCount("CATGCCATTCGCATTGTCCCAGTGA", "CCC", 2)
#puts HammingDistance("TGACCCGTTATGCTCGAGTTCGGTCAGAGCGTCATTGCGAGTAGTCGTTTGCTTTCTCAAACTCC", "GAGCGATTAAGCGTGACAGCCCCAGGGAACCCACAAAACGTGATCGCAGTCCATCCGATCATACA")
=begin

#FrequentWordsWithMismatches
in_seq1 = gets.chomp
ps = gets.chomp
ps = ps.split(" ")
k = ps[0].to_i
d = ps[1].to_i
puts FrequentWordsWithMismatches(in_seq1, k, d).join " "



#ApproximatePatternCount
Also know as count_d(sequence, pattern)
in_seq1 = gets.chomp
pattern = gets.chomp
d = gets.chomp.to_i
puts ApproximatePatternCount("CATGCCATTCGCATTGTCCCAGTGA", "CCC", 2)


#Frequent word mismatches
pattern = gets.chomp
in_seq1 = gets.chomp
d = gets.chomp.to_i
puts ApproximatePatternMatch(in_seq1, pattern, d).join(" ")



#IterativeNeighbors
in_seq1 = gets.chomp
d = gets.chomp.to_i

puts IterativeNeighbors(in_seq1, d)




#Neighbors
in_seq1 = gets.chomp
d = gets.chomp.to_i

puts Neighbors(in_seq1, d)

# ImmediateNeighbors
puts InmediateNeighbors("ACT").join(" ")


#Input for hamming distance
in_seq1 = gets.chomp
in_seq2 = gets.chomp
puts HammingDistance(in_seq1, in_seq2)
=end
