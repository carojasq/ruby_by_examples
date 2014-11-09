
def LoadTranslations
	translations = {}
	File.readlines('RNA_codon_table_1.txt').each do |line|
		ls = line.split " "
		translations[ls[0]] = "*" if ls[1].nil?
		translations[ls[0]] = ls[1]
	end
	return translations
end

def ReverseComplement(in_seq)
	maps = {'A' => 'T', 'T' => 'A', 'C' => 'G', 'G' => 'C'}
	out_seq = ""
	in_seq.split("").each do |l|
		out_seq += maps[l]
	end
	return out_seq.reverse
end


def TranscribeRNA(in_seq)
	return in_seq.gsub("U", "T")
end

def TranscribeDNA(in_seq)
	return in_seq.gsub("T", "A")
end
def LoadReverseTranslations
	translations = {}
	File.readlines('RNA_codon_table_1.txt').each do |line|
		ls = line.split " "
		ls[1] = "*" if ls[1].nil?
		translations[ls[1]] = [] if translations[ls[1]].nil?
		translations[ls[1]] << ls[0]
	end
	return translations
end

def TranslateRNA(in_seq, codons=false)
	out_seq = ""
	translations = LoadTranslations()
	(0..in_seq.length-3).step(3).each do |i|
		out_seq =  out_seq+translations[in_seq.slice(i,3)].to_s
	end
	out_seq.gsub("*", "")  if not codons
	return out_seq
end

def TranslateDNAWithReverseComplement(in_seq)
	reverse = ReverseComplement(in_seq)
	rnas = [TranscribeDNA(in_seq), TranscribeDNA(reverse)]
	proteins = []
	rnas.each do |i|
		proteins.push(TranslateRNA(i))
	end
	return proteins
end


def TranslateProtein(in_seq)
	translations = LoadReverseTranslations()
	out_seqs = [""]
	(0..in_seq.length-1).each do |i|
		#uts "#{in_seq[i]}: #{translations[in_seq[i]].reject { |e| e=='*' }.join ','}, len =  #{translations[in_seq[i]].reject { |e| e=='*' }.length.to_s}"
		out_seqs  = out_seqs.product(translations[in_seq[i]].reject { |e| e=="*" })
		out_seqs.map! {|s| s.join("")}
		t_n = 0
		last_seq = out_seqs.last+"" 	
	end
	return out_seqs
end

def PeptideEncodingProblem(in_seq, peptides)
	rna = TranscribeDNA(in_seq)
	rnas = TranslateProtein(peptides) 
	dnas = rnas.map {|r| TranscribeRNA(r)}
	dnas = dnas + dnas.map {|d| ReverseComplement(d) }
	encoding_peptides = []
	puts "There are #{dnas.length} possible DNA strings that encodes #{peptides}, looking if exists"
	encoding_peptides = dnas.select {|i| in_seq.include? i}
	puts "There are #{encoding_peptides.length} DNA strings existing "
	output = []
	(0..in_seq.length-(peptides.length*3)).each do |i|
		puts "Looking #{i}"
		encoding_peptides.each do |e|
			output.push(e) if e==in_seq.slice(i, peptides.length*3)
		end
	end
	return output
end

puts TranslateProtein("PRTEIN") & ["CCGAGGACCGAAAUCAAC", "CCCAGUACCGAAAUUAAC", "CCAAGAACAGAUAUCAAU", "CCUCGUACAGAAAUCAAC"
=begin
in_dna = gets.chomp
in_pep = gets.chomp
dna_strings  = PeptideEncodingProblem(in_dna, in_pep)
puts dna_strings
puts dna_strings.length


#in_seq = "GAAACT"
#puts TranslateDNAWithReverseComplement(in_seq).join(" ")

#TranslateRNA
#puts TranslateRNA(in_seq)
#in_seq = gets.chomp	
#protein = "VKLFPWFNGT"
#protein = "VV"
#puts LoadReverseTranslations()
#puts TranslateProtein(protein).length
=end