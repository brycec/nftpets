class Furbaby < ApplicationRecord
  validates :dna, presence: true

  SYMBOLS = ["S,M,L,s,v,l",
 "🐈‍⬛,🐈,🐕,🐅,🐆,🐩",
 "🚺,🚹,🚼,⚧,🚻,🚮",
 "🟡,🟢,🔵,🟠,🟣,🔴",
 "😻,😾,😹,🙈,👽,😈",
 "💪,🧠,🫀,🦵,👁,🫁",
 "🍐,🍎,🍑,🍍,🍓,🍌",
 "🌽,🥕,🍅,🥦,🧅,🥔",
 "🍞,🥖,🥯,🥨,🥐,🥞",
 "🌭,🥪,🌮,🍕,🍔,🌯",
 "🍬,🍰,🍫,🍭,🍦,🍩",
 "🌼,🌸,🌺,🌻,🌷,🌹",
 "🔮,🧹,👻,✨,🍄,👾",
 "🪨,📄,✂,💣,🛸,☂",
 "📼,💿,💾,📁,🗄,🗑",
 "🌳,🏔,🏜,🏝,🌋,🖼",
 "💭,💬,🗯,❔,🌀,💤",
 "📈,📉,📊,👊,️🤲,💎",
 "🌿,🔥,💧,🌈,⚡,️☢",
 "🌞,️🌛,🌏,💫,️🪐,🚀"]

  # forbidden magicks
  SYM_COORDS = {
   sun: [SYMBOLS.length-1,0],
   moon: [SYMBOLS.length-1,1],
   terra: [SYMBOLS.length-1,2],
  }

  WORDS = ["smol, reg, chonk, micro, smooshy, chungus",
    "demon, tabbrs, doge, tigger, togger, pewds",
    "she, he, they, it, both'm, neither'm",
    "yellow, green, blue, orange, magenta, red",
    "sweet, grumpy, silly, shy, weird, evil",
    "strong, smart, brave, fast, aware, efficient",
    "pear, apple, peach, pineapple, strawberry, banana",
    "corn, carrot, tomato, broccoli, onion, potato",
    "loafs, baguettes, bagels, pretzels, croissants, pancakes",
    "hotdog, sandwich, taco, pizza, burger, burrito",
    "candy, cake, chocolate, suckers, ice cream, donuts",
    "cosmos, blossoms, hibiscus, sunflowers, tulips, roses",
    "clairvoyant, telekinetic, telepathic, dusty, trippy, glitchy",
    "rock, paper, scissor, bomb, ufo, bumpershoot",
    "VHS, CD, floppy, folder, zipdrive, trashcan",
    "forest, mountains, desert, islands, volcano, windows",
    "thinking, talking, screaming, confused, rambling, dreaming",
    "buy, sell, diversify, hodl, paperhands, diamondhands",
    "nature, fire, water, rainbow, lightning, radiation",
    "sun, moon, terra, star, saturn, rocket"
  ]
  GENES = ['A','B'] # .last gene is rare
  RARE_G = 2.times.map{GENES.last.downcase}.join # the rare gene 'bb'
  NUM_GENES = 20 # (x2 chars/chromosome = dna string length)

  def description

    a = self.numerical_pheno().zip(WORDS.map{|e|
     e.split(', ').filter{|s| s.length>0} }).map {|e|
      e[1][e[0]]
    }
   sprintf(%{a %s %s.
     %s has %s eyes and acts %s,
     naturally %s and shaped like a %s,
     eats %s %s like a %s with %s,
     likes the smell of %s,
     has %s powers,
     carries a %1s and
     keeps memories stored in a %s,
     usually found in the %s
     %s about '%s %s stonks' and
     trades under the %s symbol.}, *a)
  end

  def trade_symbol
    WORDS.last.split(', ')[self.numerical_pheno.last]
  end

  def rand_dna
    self.dna = NUM_GENES.times.map {
      GENES.map{ |g|
        2.times.map{rand(2)>0 ? g : g.swapcase}.join
      }.join
    }.join
  end

  def count_rare_dna
    (dna.scan RARE_G).length
  end

  def limit_rare_dna(l)
    g = RARE_G
    while self.count_rare_dna() > l
      self.dna = self.dna.sub(g, g.upcase)
    end
  end

  def gene_from_sym(s)
    v=SYM_COORDS[s][1]
    a=2.times.map{|i|
      g=GENES[0]
      (i<v) ? g.downcase : g}.join
    b=2.times.map{GENES[1]}.join
    if v>2 then
      b=b.downcase
    end
    a+b
  end

  def ensure_symbol(s)
    s=s.to_sym
    i = SYM_COORDS[s][0] * GENES.length * 2
    g = gene_from_sym(s)
    dna = self.dna.slice(0,i)+g+self.dna.slice(i+4,self.dna.length)
  end

  def combo_dna_with(b)
    a = @dna
    p = rand(2)>0
    a.split('').zip(b.split('')).map{|g| g[rand(2)]}.join
  end

  def numerical_pheno()
    self.dna.split(/(....)/).filter{|e| e.length>0}.map{|e|
      (2 - e.scan(GENES[0]).length +
       (e.scan(GENES[1].downcase).length > 1 ? 3 : 0)
     )
   }
  end

  def pheno
    self.numerical_pheno.zip(SYMBOLS).map{|e|
      e[1].split(',')[e[0]]
    }.join
  end
  # test it: pheno_from_dna limit_rare_dna rand_dna,0
end
