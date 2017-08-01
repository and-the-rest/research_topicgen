require 'psych'

module ResearchTopicGen
  VERSION = '0.1.6'.freeze
  BZS = %i[buzz1 buzz2 buzz3]

  # Crypto Research Topic Generator
  def self.crypto
    cf = self.load_yml_data( 'crypto' )
    word1, word2, word3 = self.samples( BZS, cf )
    until word1 != word2
      word2 = cf[:buzz2].sample
    end
    pre_connective = self.add_article(word1, caps=true)
    "#{pre_connective} #{word1}, #{word2} #{word3}."
  end

  # CS Research Topic Generator
  def self.cs
    connectives_file, cs_file = self.load_file('cs')
    com_connective	= [
      connectives_file[:common_connectives].sample,
      connectives_file[:extra_connectives][1]
    ].sample

    pre_wrds = self.samples( %i[buzz1 buzz2 buzz3], cs_file )
    pst_wrds = self.samples( %i[buzz1 buzz2 buzz3], cs_file )
    pre_connective = self.add_article(pre_wrds.first, caps=true)
    mid_connective = self.add_article(pst_wrds.first)

    sentence = [
      pre_connective,
      *pre_wrds,
      com_connective,
      mid_connective,
      *pst_wrds
    ]
    "#{sentence.join ' '}."
  end

  # System Research Topic Generatorg
  def self.system
    mtds = [:generic, :approach_based, :onfoo, :looong, :ings]
    gen = SystemTopicGenerator.new
    gen.send( mtds.sample )
  end

  # Generate Random Topic
  def self.random
    topic = %w[ cs system crypto ].sample
    self.send( topic )
  end

  # System Research Topic Generatorg
  class SystemTopicGenerator
    def initialize
      @connectives_file, @system_file = ResearchTopicGen.load_file('system')
      @added = {}
      @words = []
    end

    # generic: [name]: [word1], [word2] [word3]
    def generic
      w1_3 = format_words( 0, caps = true )
      "#{gen_word( :names )}: #{w1_3}"
    end

    # approach-based: [generic] - [a/an] [buzz2] approach
    def approach_based
      buzz2 = gen_word :buzz2
      article = ResearchTopicGen.add_article( buzz2 )
      "#{generic} - #{article} #{buzz2} approach"
    end

    # on...: on[foo]s
    def onfoo
      foo = format_words( 0, article=false )
      "on #{foo}s"
    end

    # [generic] [a/an] [buzz1], [buzz2] [buzz3]s
    def looong
      rest = format_words( 4 )
      "#{generic} #{rest}s"
    end

    # [ing] [buzz1] [buzz2] [buzz3]s
    def ings
      ing = gen_word( :ings )
      rest = format_words(0, article=false)
      "#{ing} #{rest}s"
    end

    private

    def format_words( offset, caps = false, article = true )
      gen_words # (re-)generate a fresh set of words
      ws = @words[offset, 3]
      bz1 = ws.first
      bz2_3 = ws[1, 2].join( ' ' )
      article = article ? ResearchTopicGen.add_article( bz1, caps ) : ''
      "#{article} #{bz1}, #{bz2_3}"
    end

    def gen_word( bz )
      loop do
        word = @system_file[bz].sample
        unless @added[word]
          @added[word] = true
          return word
        end
      end
    end

    def gen_words
      # flush stored results
      @added = {}
      @words = []
      BZS.cycle(2).map do |bz|
        @words.push gen_word( bz )
      end
      @words.insert(3, gen_word(:buzz2))
    end
  end


  def self.add_article(word, caps=false)
    if word.downcase.start_with?('a', 'e', 'i', 'o', 'u')
      article = "an"
    else
      article = 'a'
    end
    caps ? article.capitalize : article
  end

  def self.samples( keys , table )
    keys.map { |key| table[key].sample }
  end

  def self.load_yml_data(topic)
    data = File.join( File.dirname(__FILE__), "data", "#{topic}.yml" )
    Psych.load_file( data )
  end

  def self.load_file(topic)
    conf = load_yml_data('connectives')
    [ conf, load_yml_data(topic) ]
  end
end
