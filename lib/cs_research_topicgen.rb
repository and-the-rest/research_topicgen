
module CsResearchTopicGen
	
	@@buzz1 = [
			 "integrated",
			 "parallel",
			 "virtual",
			 "interactive", 
			 "responsive",
			 "synchronized", 
			 "balanced",
			 "virtual",
			 "meta-level",
			 "optimized",
			 "active",
			 "parameterized", 
		     "conceptual", 
			 "scalable",
			 "dynamic", 
			 "high-level", 
			 "collaborative",
			 "type-safe",
			 "reliable",
			 "open",
 			 "coordinated"
	]

	@@buzz2 = [
			"mobility", 
			"functional", 
			"programmable",
			"distributed", 
			"logical",
			"digital", 
			"concurrent",
			"knowledge-based",
			"multimedia",
			"binary",
			"object-oriented",
			"secure",
			"high-speed", 
			"real-time",
			"functional",
			"parallelizing",
			"watermarking",
			"proxy",
			"cloud-based",
			"big data", 
			"bioinformatic",
			"multi-core"
	]

	@@buzz3 = [
			 "network",
	     	 "preprocessor",
			 "compiler", 
			 "system",
			 "interface",
			 "protocol", 
			 "architecture",
			 "database",
			 "algorithm",
			 "toolkit",
			 "display",
			 "technology",
			 "solution",
			 "language", 
			 "agent", 
			 "theorem prover",
			 "work cluster",
			 "cache",
			 "network", 
			 "data center",
			 "hypervisor"
	]

	@@connectives = [ 
			"for",
			"related to",
			"derived from", 
			"applied to",
			"embedded in" 
	]


	# Function to generate the final output
	def self.generate()
		sentence = [ @@buzz1.sample, @@buzz2.sample, @@buzz3.sample, @@connectives.sample, @@buzz1.sample, @@buzz2.sample, @@buzz3.sample]
		pre_connective = vowel_check( sentence[0], true)
		mid_connective = vowel_check( sentence[4], false)
		sentence.insert(0, pre_connective) # #insert used to mainatin the style
		sentence.insert(5, mid_connective) 
		return sentence.join(' ')
	end

	def self.vowel_check(word, caps)
		
		if word.match(/^[aeiou]/i) 
			article = "an"
		else
			article = 'a'
		end			
	 return caps ? article.capitalize : article
	end
end
