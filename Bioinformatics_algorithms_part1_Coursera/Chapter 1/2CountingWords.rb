def PatternCount(text,pattern)
     count = 0
     pl = pattern.length  # Pattern lenght
     (0..text.length).each do |n|
         count = count + 1 if text[n..n+pl-1] == pattern
	 puts text[n..n+pl]
     end
     return count
end
a = gets.chomp
p = gets.chomp
puts PatternCount(a,p)
