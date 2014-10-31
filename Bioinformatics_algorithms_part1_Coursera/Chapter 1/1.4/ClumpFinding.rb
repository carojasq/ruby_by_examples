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

=begin
	   PatternToNumber(Pattern)
        if Pattern contains no symbols
            return 0
        symbol ← LastSymbol(Pattern)
        remove LastSymbol(Pattern) from Pattern
        return 4 · PatternToNumber(Pattern) + SymbolToNumber(symbol)

	
=end

def PatternToInteger(pattern)
	symbols = ["A", "C", "G", "T"]
	if pattern == ""
		return 0
	end
	s = pattern[-1]
	pattern[-1]=""
	return (4 * PatternToInteger(pattern)) + symbols.find_index(s)
	#return ["A", "C", "G", "T"].repeated_permutation(pattern.length).find_index(pattern.split(""))
end

def IntegerToPattern(integer, pattern_length)
	return ["A", "C", "G", "T"].repeated_permutation(pattern_length).take(integer+1).last.join("")
end

def ComputingFrequencies(text, k)
	frequency_array = []
    (0..4**k-1).each do |i|
    	frequency_array[i] = 0
    end
    (0..text.length-k).each do |i|
    	pattern = text[i..i+k-1]
    	j = PatternToInteger(pattern)
    	frequency_array[j] += 1
    end
    return frequency_array
end


def FasterFrequentWords	(in_seq, k)
	frequent_patterns = []
	frequency_array = ComputingFrequencies(in_seq,k)
	maxcount = frequency_array.max
	indices = frequency_array.each_index.select{|i| frequency_array[i]==maxcount}
	indices.each do |i|
		frequent_patterns << IntegerToPattern(i, k)
	end
	return frequent_patterns
end


def ClumpFinding(in_seq, k, l, t)
	clumps = []
	(l..in_seq.length - k).each do |i|
		puts i
		clumps << FasterFrequentWords(in_seq[i-l..i], k)
	end
	return clumps.sort
end

in_seq = gets.chomp
puts PatternToInteger(in_seq)
=begin
in_seq = gets.chomp
parameters = gets.chomp
puts parameters
parameters = parameters.split(" ")
k = parameters[0].to_i
l = parameters[1].to_i
t = parameters[2].to_i
fw = ClumpFinding(in_seq, k, l, t)
puts fw.join " "
=end
=begin
#Input for computing frequences
in_seq = gets.chomp
k = gets.chomp.to_i
puts ComputingFrequencies(in_seq, k).join " "
=each_index

=begin
#Input for FasterFrequentWords
in_seq = gets.chomp()
in_seq.upcase!
k = gets.chomp.to_i
puts FasterFrequentWords(in_seq, k).join " "
=each_index

#PSEUDOCODE
=begin
    ComputingFrequencies(Text , k)
        for i ← 0 to 4k − 1
            FrequencyArray(i) ← 0
        for i ← 0 to |Text| − k
            Pattern ← Text(i, k)
            j ← PatternToNumber(Pattern)
            FrequencyArray(j) ← FrequencyArray(j) + 1
        return FrequencyArray
=end

=begin
	
    FasterFrequentWords(Text , k)
        FrequentPatterns ← an empty set
        FrequencyArray ← ComputingFrequencies(Text, k)
        maxCount ← maximal value in FrequencyArray
        for i ←0 to 4k − 1
            if FrequencyArray(i) = maxCount
                Pattern ← NumberToPattern(i, k)
                add Pattern to the set FrequentPatterns
        return FrequentPatterns => e
=end
	