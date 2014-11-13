def LoadMassTable()
	masses = {}
	File.readlines('integer_mass_table.txt').each do |line|
		ls = line.split " "
		masses[ls[0]] = ls[1].to_i
	end
	return masses
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


def HowManySubPeptides(n)
	subpeptides = 0
	(1..n-1).each do |i|
		subpeptides = subpeptides + n
	end
	return subpeptides
end



peptide = gets.chomp
puts CyclicSpectrum(peptide).join " "
#puts CyclicSpectrum("IAQMLFYCKVATN").join " "


# https://stepic.org/lesson/CS-Generating-the-Theoretical-Spectrum-of-a-Peptide-4912/step/2
#puts LinearSpectrum("NQEL").join " "

#puts PrefixMass("NQEL")

#puts CycloSpectrum("IAQMLFYCKVATN").join " "

#puts Spectrum("EL")

#puts LoadMassTable()

#tyrocidine = "VKLFPWFNQY"
#n = gets.chomp.to_i
#puts HowManySubPeptides(n)