a = (1..5).map { |num| num**2 }
puts a.to_s
puts a.map(&:odd?).select{|e| e== true}.to_s
puts a.map(&:odd?).select{|e| e== true}.count
puts [1,2,3,4,5,6,7,8,9,10].reject{|e| e==2 || e==8}.to_s