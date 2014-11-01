def PatternCount(text,pattern)
     count = 0
     pl = pattern.length  # Pattern lenght
     (0..text.length-pl).each do |n|
         count = count + 1 if text[n..n+pl-1] == pattern
     end
     return count
end

def FrequentWords(in_seq, k, t=3)
	frequent_patterns = []
	counts = []
	counted_words = {}
	(0..in_seq.length-k).each do |i|
		counts[i] = PatternCount(in_seq, in_seq[i..i+k-1])
	end
	max = counts.max
	#Optimal filter
	indices = counts.each_index.select{|i| counts[i]>=t}
	indices.each do |v|
		frequent_patterns<<in_seq[v..v+k-1]
	end
	return frequent_patterns.uniq!
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


def ComputingFrequencies(text, k)
	frequency_array = []
	#puts "Initializing array"
    (0..4**k-1).each do |i|
    	frequency_array[i] = 0
    end

    #puts "Checking frequences for #{frequency_array.length} patterns"
    (0..text.length-k).each do |i|
    	pattern = text[i..i+k-1]
    	j = PatternToInteger(pattern)
    	frequency_array[j] += 1
    end
    return frequency_array
end


def FasterFrequentWords	(in_seq, k, t=-1)
	frequent_patterns = []
	#puts "Computing frequences"
	frequency_array = ComputingFrequencies(in_seq,k)

	if t==-1
		maxcount = frequency_array.max
		indices = frequency_array.each_index.select{|i| frequency_array[i]==maxcount}
	else 
		indices = frequency_array.each_index.select{|i| frequency_array[i]>=t}
	end

	#puts "Selecting patterns"
	indices.each do |i|
		frequent_patterns << IntegerToPattern(i, k)
	end
	return frequent_patterns
end



def ClumpFinding(in_seq, k, l, t)
	frequent_patterns = []
	clump  = []
	puts "Initializing array"
	(0..4**k-1).each  do |i|
		clump[i]=0
	end
	puts "Computing Frequences"
	(0..in_seq.length - l).each do |i|
		text = in_seq[i..i+l]
		frequency_array = ComputingFrequencies(text, k)
		(0..4**k -1).each do |j|
			if frequency_array[j] >= 7
			    clump[j]  = 1
			end
        end
    end
    puts "Adding frequent patterns"
    (0..4**k -1).each do |i|
		if clump[i] == 1
			frequent_patterns << IntegerToPattern(i, k)
		end
	end
	return frequent_patterns
end

=begin 
    BetterClumpFinding(Genome, k, t, L)
        FrequentPatterns ← an empty set
        for i ←0 to 4k − 1
            Clump(i) ← 0
        Text ← Genome(0, L)
        puts "Computing frequencies"
        FrequencyArray ← ComputingFrequencies(Text, k)
        for i ← 0 to 4k − 1
            if FrequencyArray(i) ≥ t
                Clump(i) ← 1
        for i ← 1 to |Genome| − L
            FirstPattern ← Genome(i − 1, k)
            j ← PatternToNumber(FirstPattern)
            FrequencyArray(j) ← FrequencyArray(j) − 1
            LastPattern ← Genome(i + L − k, k)
            j ← PatternToNumber(LastPattern)
            FrequencyArray(j) ← FrequencyArray(j) + 1
            if FrequencyArray(j) ≥ t
                Clump(j) ← 1
        for i ← 0 to 4k − 1
            if Clump(i) = 1
                Pattern ← NumberToPattern(i, k)
                add Pattern to the set FrequentPatterns
        return FrequentPatterns
=end
def BetterClumpFinding(in_seq, k, l, t)
	frequent_patterns = []
	clump  = []
	puts "Initializing array"
	(0..(4**k)-1).each  do |i|
		clump[i]=0
	end
	text = in_seq[0..l-1]
	puts "Computing frequencies"
	frequency_array  = ComputingFrequencies(text, k)
	(0..(4**k) - 1).each do |i|
		if frequency_array[i] >= t
			clump[i] = 1
		end
	end
	puts "Slicing the window"
	(1..in_seq.length-l).each do |i|
		first_pattern = in_seq[i-1..i-1+k-1]
		j = PatternToInteger(first_pattern)
		frequency_array[j] -= 1
		last_pattern = in_seq[i+l-k..i+l-k+k-1]
		j = PatternToInteger(last_pattern)
		frequency_array[j] += 1
		if frequency_array[j] >= t
			clump[j] = 1
		end
	end
	puts "Adding patterns to frequent_patterns"
	(0..(4**k)-1).each do |i|
		if clump[i]==1
				frequent_patterns << IntegerToPattern(i,k)
		end
	end
	return frequent_patterns
end


in_seq = gets.chomp
ps = gets.chomp
ps = ps.split(" ")
k = ps[0].to_i
l = ps[1].to_i
t = ps[2].to_i
kmers = BetterClumpFinding(in_seq, k, l, t)
puts kmers.join(" ")
puts "Total #{kmers.length}"



=begin
#Input for FasterFrequentWords
in_seq = gets.chomp
k = gets.chomp.to_i
puts FasterFrequentWords(in_seq, k)

#Input for Integer to Pattern
integer = gets.chomp.to_i
k = gets.chomp.to_i
puts IntegerToPattern(integer, k)

#puts PatternToInteger(in_seq)
in_seq = gets.chomp
parameters = gets.chomp
puts parameters
parameters = parameters.split(" ")
k = parameters[0].to_i
l = parameters[1].to_i
t = parameters[2].to_i
fw = ClumpFinding(in_seq, k, l, t)
puts fw.join " "


#Input for computing frequences
in_seq = gets.chomp
k = gets.chomp.to_i
puts ComputingFrequencies(in_seq, k).join " "


#Input for FasterFrequentWords
in_seq = gets.chomp()
in_seq.upcase!
k = gets.chomp.to_i
puts FasterFrequentWords(in_seq, k).join " "

#PSEUDOCODE


ComputingFrequencies(Text , k)
    for i ← 0 to 4k − 1
        FrequencyArray(i) ← 0
    for i ← 0 to |Text| − k
        Pattern ← Text(i, k)
        j ← PatternToNumber(Pattern)
        FrequencyArray(j) ← FrequencyArray(j) + 1
    return FrequencyArray




FasterFrequentWords(Text , k)
    FrequentPatterns ← an empty set
    FrequencyArray ← ComputingFrequencies(Text, k)
    maxCount ← maximal value in FrequencyArray
    for i ←0 to 4k − 1
        if FrequencyArray(i) = maxCount
            Pattern ← NumberToPattern(i, k)
            add Pattern to the set FrequentPatterns
    return FrequentPatterns => e
	

In the pseudocode below, we denote the quotient and the remainder when dividing integer n by integer m as Quotient(n, m) and Remainder(n, m), respectively. For example, Quotient(11, 4) = 2 and Remainder(11, 4) = 3. This pseudocode uses the function NumberToSymbol(index), which is the inverse of SymbolToNumber and transforms the integers 0, 1, 2, and 3 into the respective symbols A, C, G, and T.


NumberToPattern(index, k)
    if k = 1
        return NumberToSymbol(index)
    prefixIndex ← Quotient(index, 4)
    r ← Remainder(index, 4)
    PrefixPattern ← NumberToPattern(prefixIndex, k − 1)
    symbol ← NumberToSymbol(r)
    return concatenation of PrefixPattern with symbol


PatternToNumber(Pattern)
    if Pattern contains no symbols
        return 0
    symbol ← LastSymbol(Pattern)
    remove LastSymbol(Pattern) from Pattern
    return 4 · PatternToNumber(Pattern) + SymbolToNumber(symbol)



 ClumpFinding(Genome, k, t, L)
        FrequentPatterns ← an empty set
        for i ←0 to 4k − 1
            Clump(i) ← 0
        for i ← 0 to |Genome| − L
            Text ← the string of length L starting at position i in Genome 
            FrequencyArray ← ComputingFrequencies(Text, k)
            for j ← 0 to 4k − 1
                if FrequencyArray(j) ≥ t
                    Clump(j) ← 1
        for i ← 0 to 4k − 1
            if Clump(i) = 1
                Pattern ← NumberToPattern(i, k)
                add Pattern to the set FrequentPatterns
        return FrequentPatterns	

=end