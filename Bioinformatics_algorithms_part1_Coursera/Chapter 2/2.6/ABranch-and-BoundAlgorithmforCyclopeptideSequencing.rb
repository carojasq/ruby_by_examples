require 'set'

def Expand(peptide)
	aminoacids = ["G", "A", "S", "P", "V", "T", "C", "I", "L", "N", "D", "K", "Q", "E", "M", "H", "F", "R", "Y", "W"]
	sub_peptides = []
	peptide.product(aminoacids).each do |sp|
		sub_peptides.push(sp.join "")
	end
	return sub_peptides
end


def LoadMassTable()
	masses = {}
	File.readlines('integer_mass_table.txt').each do |line|
		ls = line.split " "
		masses[ls[0]] = ls[1].to_i
	end
	return masses
end

def Mass(sequence)
	spectrum = 0
	masses = LoadMassTable()
	sequence.split("").each do |i|
		spectrum += masses[i]
	end
	return spectrum
end
 
def PrefixMass(sequence)
	prefix_mass = []
	(0..sequence.length).each do |i|
		prefix_mass.push(Spectrum(sequence.slice(0, i)))
	end
	return prefix_mass
end

def LinearSpectrum(peptide )
	prefix_mass = PrefixMass(peptide)
	aminoacid_mass = LoadMassTable()
	linear_spectrum = [0]
	(0..peptide.length-1).each do |i|
		(i+1..peptide.length).each do |j|
			linear_spectrum.push(prefix_mass[j]-prefix_mass[i])
		end
	end
	return linear_spectrum.sort
end


def CyclicSpectrum(peptide)
	prefix_mass =  PrefixMass(peptide)
	cyclic_spectrum = [0]
	#duplicate_sequence = sequence * 2 # For cyclic
	peptide_mass = prefix_mass.last
	(0..peptide.length-1).each do |i|
		(i+1..peptide.length).each do |j|
			cyclic_spectrum.push(prefix_mass[j]-prefix_mass[i])
			cyclic_spectrum.push(peptide_mass - (prefix_mass[j]-prefix_mass[i])) if (i>0 and j<peptide.length)
		end
	end
	return cyclic_spectrum.sort
end

def Spectrum(sequence)
	spectrum = 0
	masses = LoadMassTable()
	sequence.split("").each do |i|
		spectrum += masses[i]
	end
	return spectrum
end

def PeptiteIsConsistent(peptide, spectrumset)
	(1..peptide.length+1).each do |i| 
		subpetides = []
		(0..peptide.length-i+1).each do |j|
			subpetides.push(peptide.slice(j, l))
		end

 	end
end

def CycloPeptideSequencing(spectrum)
	peptides = [""]
	valid_sequences = []
	peptides_copy = []
	peptides.each do |p|
		peptides_copy.push(p)
	end
	parent_mass = spectrum.max
	spectrum_set = spectrum.to_set
	while not peptides_copy.empty?
		peptides = Expand(peptides_copy)
		puts "Copying peptides to another array, actual peptide length=#{peptides.last.length}"
		peptides_copy = []
		peptides.each do |p|
			peptides_copy.push(p)
		end
		peptides.each do |peptide|
			if Mass(peptide) == parent_mass
				if CyclicSpectrum(peptide) == spectrum
					valid_sequences<<peptide
				end
				peptides_copy.delete(peptide)
			elsif not (LinearSpectrum(peptide).to_set - spectrum).empty? # Is subset?
				peptides_copy.delete(peptide)
			end
		end
	end
	return valid_sequences
end


def Peptides2Masses(peptides)
	aminoacid_mass = LoadMassTable()
	masses_list = []
	peptides.each do |pep|
		mass_list = []
		pep.split("").each do |aminoacid|
			mass_list.push(aminoacid_mass[aminoacid])
		end
		masses_list.push(mass_list.join "-")
	end
	return masses_list.uniq.sort
end



#spectrum="0 71 97 99 103 113 113 114 115 131 137 196 200 202 208 214 226 227 228 240 245 299 311 311 316 327 337 339 340 341 358 408 414 424 429 436 440 442 453 455 471 507 527 537 539 542 551 554 556 566 586 622 638 640 651 653 657 664 669 679 685 735 752 753 754 756 766 777 782 782 794 848 853 865 866 867 879 885 891 893 897 956 962 978 979 980 980 990 994 996 1022 1093".split(" ").map {|n| n.to_i}
spectrum=gets.chomp.split(" ").map {|n| n.to_i}
puts "Detecting possible candidates"
candidates =  CycloPeptideSequencing(spectrum)
puts "Calculating masses"
masses_candidates = Peptides2Masses(candidates)
puts masses_candidates.join " "

