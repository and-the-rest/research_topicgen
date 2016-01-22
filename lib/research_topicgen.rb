require 'psych'

module ResearchTopicGen
  VERSION = '0.1.3'.freeze

  def self.load_yml_data(topic)
    Psych.load_file(File.join(File.dirname(__FILE__), "data", "#{topic}.yml"))
  end

  def self.load_file(topic)
    case topic
    when 'cs'
      [load_yml_data('connectives'), load_yml_data('cs_data')]
    when 'system'
      [load_yml_data('connectives'), load_yml_data('system_data')]
    when 'crypto'
      load_yml_data('crypto_data')
    end
  end
	
  # CS Research Topic Generator
  def self.cs
    connectives_file, cs_file = self.load_file('cs')
    connectives	= *connectives_file[:common_connectives], *connectives_file[:extra_connectives][1]
    connectives.flatten! 
    sentence = [cs_file[:buzz1].sample,	
           cs_file[:buzz2].sample,
           cs_file[:buzz3].sample,
           connectives.sample,
           cs_file[:buzz1].sample,
           cs_file[:buzz2].sample,
           cs_file[:buzz3].sample
         ]
     pre_connective = ResearchTopicGen.add_article(sentence[0], true)
     mid_connective = ResearchTopicGen.add_article(sentence[4], false)
     sentence.insert(0, pre_connective)
     sentence.insert(5, mid_connective)
     "#{sentence.join(' ')}."
  end

  # System Research Topic Generatorg
  def self.system
    connectives_file, system_file = self.load_file('system')
    connectives = *connectives_file[:common_connectives], *connectives_file[:extra_connectives][0]
    connectives.flatten!
    word1, word2, word3, word4 = system_file[:buzz1].sample, system_file[:buzz2].sample, system_file[:buzz3].sample, system_file[:buzz2].sample
    name, ingword = system_file[:names].sample, system_file[:ings].sample
  
    word2, word3, word4  =
      case
  		when word2 == word1
  			self.random_word(system_file, 1, word1, word2)
  		when word3 == word1 || word3 == word2
  			self.random_word(system_file, 2, word1, word2, word3)
  		when word4 == word2 || word4 == word3 || word4 == word1
  			self.random_word(system_file, 3, word1, word2, word3, word4)
  		else
  			[word2,	word3,	word4]
  		end
    
    # generic: [name]: [word1], [word2] [word3]
    pre_connective = self.add_article(word1, true)
    result1 = "#{name}: #{pre_connective} #{word1}, #{word2} #{word3}"
    	
    # approach-based: [generic] - [a/an] [buzz2] approach
    mid_connective = self.add_article(word4, false)
    result2	= "#{name}:#{word1}, #{word2} #{word3}s-- #{mid_connective} #{word4} approach"
    	
    # on...: on[foo]s
    result3 = "On #{word1}, #{word2} #{word3}s"
    word5, word6, word7 = system_file[:buzz1].sample, system_file[:buzz2].sample, system_file[:buzz3].sample
    mid_connective = self.add_article(word5, false)
    word6 = self.random_word(system_file, 4, word1, word2, word3, word5, word6) if word5 == word6 || word5 == word3 || word5 == word2 || word5 == word1
    word7 = self.random_word(system_file, 5, word1, word2, word3, word5, word6, word7) if word7 == word5 || word7 == word6 || word7 == word3 || word7 == word2 || word7 == word1
    result4 = "#{result1} #{mid_connective} #{word5} #{word6} #{word7}s"
    result5 = "#{ingword} #{word1}, #{word2} #{word3}s"
    results = [result1, result2, result3, result4, result5]
    "#{results.sample}."
  end

  # Crypto Research Topic Generator
  def self.crypto
    crypto_file = self.load_file('crypto')
    word1, word2, word3 = crypto_file[:buzz1].sample, crypto_file[:buzz2].sample, crypto_file[:buzz3].sample
    word2 = word2.match(word1) ? ResearchTopicGen.random_word(crypto_file, 1, word1, word2) : word2		#If word1 and word2 are same, replace word2 with a different word.
    pre_connective = ResearchTopicGen.add_article(word1, true)
    sentence = "#{pre_connective} #{word1}, #{word2} #{word3}."
  end

  # Generate Random Topic
  def self.random
    result = [ResearchTopicGen.cs, ResearchTopicGen.system, ResearchTopicGen.crypto].sample
  end

  # Logic here needs a change.
  def self.random_word(file, checks, *col)
    if checks == 2
    	col[2] = file[:buzz3].sample until col[0] != col[2] || col[1] != col[2] 
    	col[1..checks]
    elsif checks == 3
    	col[3] = file[:buzz2].sample until col[3] != col[1] || col[3] != col[2] || col[3] != col[0] 
    	col[1..checks]
    elsif checks == 4
    	col[4] = file[:buzz2].sample until col[3] != col[4] || col[3] != col[2] || col[3] != col[1] || col[3] != col[0]
    elsif checks == 5
    	col[5] = file[:buzz3].sample until col[5] != col[3] || col[5] != col[4] || col[5] != col[2] || col[5] != col[1]
    else
    	col[1] = file[:buzz2].sample until col[0] != col[1]
      col[1]
    end
  end

  # return the correct article
  def self.add_article(word, caps)
    if word.match(/^[aeiou]/i) 
    	article = "an"
    else
    	article = 'a'
    end			
      caps ? article.capitalize : article
    end
end

