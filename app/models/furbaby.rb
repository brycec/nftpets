class Furbaby < ApplicationRecord
  has_and_belongs_to_many :parents, class_name: "Furbaby",
    foreign_key: "furbaby_id",
    association_foreign_key: "parent_id",
    join_table: "furbabies_parents"
  has_and_belongs_to_many :children, class_name: "Furbaby",
    foreign_key: "parent_id",
    association_foreign_key: "furbaby_id",
    join_table: "furbabies_parents"
  has_one :token
  validates :dna, presence: true
  scope :with_symbol, ->(s) {
    where("dna ~ ?", QUERYS[s])
  }
  scope :not_egg, -> {
    where.not(created_at: DateTime.new)
  }

  EMOJI = [
 %w(🚺 🚹 🚼 ⚧ 🚻 🚮),
 %w(S M L s v l),
%w(🐈‍⬛ 🐈 🐕 🐅 🐆 🐩),
%w(🟡 🟢 🔵 🟠 🟣 🔴),
%w(😻 😾 😹 🙈 👽 😈),
%w(💪 🧠 🫀 🦵 👁 🫁),
%w(🍐 🍎 🍑 🍍 🍓 🍌),
%w(🌽 🥕 🍅 🥦 🧅 🥔),
%w(🍞 🥖 🥯 🥨 🥐 🥞),
%w(🌭 🥪 🌮 🍕 🍔 🌯),
%w(🍬 🍰 🍫 🍭 🍦 🍩),
%w(🌼 🌸 🌺 🌻 🌷 🌹),
%w(🔮 🧹 👻 ✨ 🍄 👾),
%w(🪨 📄 ✂️ 💣 🛸 ☂),
%w(📼 💿 💾 📁 🗄 🗑),
%w(🌳 🏔 🏜 🏝 🌋 🖼),
%w(💭 💬 🗯 ❔ 🌀 💤),
%w(📈 📉 📊 👊 ️🤲 💎),
%w(🌿 🔥 💧 🌈 ⚡ ️☢),
%w(🌞 🌛 🌏 💫 ️🪐 🚀)]

 WORDS = [
  %w(she he they it both'm neither'm),
  %w(smol reg chonk micro smooshy chungus),
  %w(felid tab doge tigger kitty pewds),
  %w(yellow green blue orange magenta red),
  %w(sweet grumpy silly shy weird evil),
  %w(strong smart brave fast aware efficient),
  %w(pear apple peach pineapple strawberry banana),
  %w(corn carrot tomato broccoli onion potato),
  %w(loafs baguettes bagels pretzels croissants pancakes),
  %w(hotdog sandwich taco pizza burger burrito),
  %w(candy cake chocolate lolipop icecream donuts),
  %w(cosmos blossoms hibiscus sunflowers tulips roses),
  %w(clairvoyant telekinetic telepathic dusty trippy glitchy),
  %w(rock paper scissor bomb ufo bumpershoot),
  %w(VHS CD floppy folder zipdrive trashcan),
  %w(forest mountains desert islands volcano windows),
  %w(thinking talking screaming confused rambling dreaming),
  %w(buy sell diversify hodl paperhands diamondhands),
  %w(nature fire water rainbow lightning radiation),
  %w(sun moon terra star saturn rocket)]

  # forbidden magicks
  EMOJI_COORDS = WORDS.zip(EMOJI).each_with_index.inject({}) do |m, (e, i)|
    e[0].each_with_index do |w,j|
      m[w.to_sym]=[i,j]
    end
    m
  end

  TRADE_SYMS = WORDS.last.zip(EMOJI.last).take(3).inject({}) do |m, e|
    m[e[0].to_sym]=e[1]
    m
  end

  GENES = ['A','B'] # .last gene is rare
  RARE_G = 2.times.map{GENES.last.downcase}.join # the rare gene 'bb'
  NUM_GENES = EMOJI.length # (20x4 chars/chromosome = dna string length)

  # TO DO
  QUERYS = ["AA","(Aa|aA)","aa"].map do |e|
    ("^"+"."*((NUM_GENES-1)*GENES.length*2))+e+".."
  end

  ASTRO = [[20,'♑️ capricorn'],
    [19,'♒️ aquarius',],
    [21,'♓️ pisces'],
    [20,'♈️ aries'],
    [21,'♉️ taurus'],
    [21,'♊️ gemini'],
    [23,'♋️ cancer'],
    [23,'♌️ leo'],
    [23,'♍️ virgo'],
    [23,'♎️ libra'],
    [22,'♏️ scorpio'],
    [22,'♐️ sagittarius']]

  def vocab
    self.numerical_pheno.zip(WORDS).map{|e|
      e[1][e[0]]
    }
  end

  def astro
    c=self.created_at.to_datetime
    a=ASTRO[c.month-1]
    if a[0]<c.day
      a=ASTRO[c.month]
      if !a
        a=ASTRO.first
      end
    end
    a[1]
  end

  def description

   a = self.vocab
   sprintf(%{%s is a %s %s
     with %s eyes and acts %s,
     naturally %s and shaped like a %s,
     eats %s %s like a %s with %s,
     likes the smell of %s,
     has %s powers,
     carries a %1s and
     keeps memories stored in a %s,
     usually found in the %s
     %s about '%s %s stonks' and
     trades under the %s symbol.}, *a).capitalize
  end

  def trade_s
    self.numerical_pheno.last
  end

  def trade_symbol
    WORDS.last[self.trade_s]
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
    v=EMOJI_COORDS[s][1]
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
    i = EMOJI_COORDS[s][0] * GENES.length * 2
    g = gene_from_sym(s)
    self.dna = self.dna.slice(0,i)+g+self.dna.slice(i+4,self.dna.length)
  end

  def combo_dna_with(b)
    self.dna=self.dna.split('').zip(b.split('')).map{|g|
      g[rand(2)]}.join
  end

  def numerical_pheno()
    self.dna.split(/(....)/).filter{|e| e.length>0}.map{|e|
      (2 - e.scan(GENES[0]).length +
       (e.scan(GENES[1].downcase).length > 1 ? 3 : 0)
     )
   }
  end

  def pheno
    self.numerical_pheno.zip(EMOJI).map{|e|
      e[1][e[0]]
    }.join
  end

  def full_name
    if self.name
      self.name.split(',').map{|e|
        self.vocab[e.to_i].capitalize
      }.join(' ')
    end
  end

  def rarity
    return "⭐️"*self.count_rare_dna
  end

  def dname
    if self.egg?
      "🥚 egg"
    else
      n = self.full_name
      if !n
        v = self.vocab
        n = sprintf("%s a %s",v[0],v[2])
      end
        p=self.numerical_pheno
        EMOJI[0][p[0]]+EMOJI[2][p[2]]+EMOJI.last[p.last] + ' ' + n
    end
  end

  def mature?
    self.name and self.token.vibes>0
  end

  def heat?
    self.mature? and self.numerical_pheno[0]==0
  end

  def stud?
    self.mature? and self.numerical_pheno[0]==1
  end

  def mutant?
    self.mature? and self.numerical_pheno[0]==2
  end

  def egg?
    self.created_at==DateTime.new
  end

  def hatch a
    if self.egg?
      self.combo_dna_with a.dna
      self.created_at=DateTime.now
      self.parents<< a
    end
  end
  def inject_dna_with(b)
    self.combo_dna_with(Furbaby.new.rand_dna)
    self.combo_dna_with(b.dna)
    if !self.parents.include? b
      self.parents<< b
    end
  end
end

def Furbaby.new_egg(mom)
  f=Furbaby.new
  f.dna=mom.dna
  f.save
  f.parents<< mom
  f.created_at=DateTime.new
  f.save
  f
end
