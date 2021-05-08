module FurbabiesHelper
  SYMBOLS = ["S,M,L,s,v,l",
 "🐈‍⬛,🐈,🐕,🐅,🐆,🐩",
 "🚺,🚹,🚼,⚧,🚻,🚮",
 "🟡,🟢,🔵,🟠,🟣,🔴",
 "😻,😾,😹,🙈,👽,🤡",
 "💪,🧠,🫀,🦵,👁,🫁",
 "🍐,🍎,🍑,🍍,🍓,🍌",
 "🌽,🥕,🍅,🥦,🧅,🥔",
 "🍞,🥖,🥯,🥨,🥐,🥞",
 "🌭,🍔,🌮,🍕,🥪,🌯",
 "🍬,🍰,🍫,🍭,🍦,🍩",
 "🌼,🌸,🌺,🌻,🌷,🌹",
 "🌞,️🌛,🌏,☄,️🪐,🚀",
 "🔮,🧹,👻,✨,🍄,👾",
 "🪨,📄,✂,💣,🛸,☂",
 "📼,💿,💾,📁,🗄,🗑",
 "🌳,🏔,🏜,🏝,🌋,🖼",
 "💭,💬,🗯,❔,🌀,💤",
 "📈,📉,📊,♻,️🛢,💎",
 "🌿,🔥,💧,🌈,⚡,️☢"]

  GENES = ['A','B'] # .last gene is rare
  RARE_G = 2.times.map{GENES.last.downcase}.join # the rare gene 'bb'
  NUM_GENES = 20 # (x2 chars = dna length)
  def rand_dna()
    NUM_GENES.times.map {
      GENES.map{ |g|
        2.times.map{rand(2)>0 ? g : g.swapcase}.join
      }.join
    }.join
  end

  def count_rare_dna(a)
    (a.scan RARE_G).length
  end

  def limit_rare_dna(a, l)
    g = RARE_G
    if count_rare_dna(a) > l then
      limit_rare_dna(a.sub(g, g.upcase), l)
    else
      a
    end
  end

  def combo_dna(a, b)
    p = rand(2)>0
    a.split('').zip(b.split('')).map{|g| g[rand(2)]}.join
  end

  def pheno_from_dna(a)
    a.split(/(....)/).filter{|e| e.length>0}.zip(SYMBOLS).map{|e|
      c = 2 - e[0].scan(GENES[0]).length +
       (e[0].scan(GENES[1].downcase).length > 1 ? 3 : 0)

      e[1].split(',')[c]
    }.join
  end
  # test it: pheno_from_dna limit_rare_dna rand_dna,0
end











NOTES='''
Neptunium Furbabies
🐾🧬🦠🧪⚗️
4 chromosomes AaBb
3 common phenotypes / 3 rare only with bb
Any B is common
AA[Bx] Aa[Bx] aa[Bx] / AA[bb] Aa[bb] aa[bb]


1. Size: S M L / s v l
2. Breed: 🐈‍⬛🐈🐕/🐅🐆🐩
3. Gender: 🚺🚹🚼/⚧🚻🚮
4. Eyes: 🟡🟢🔵/🟠🟣🔴
5. Personality: 😻😾😹/🙈👽🤡
6. Talent: 💪🧠🫀/🦵👁🫁
7. Shape: 🍐🍎🍑/🍍🍓🍌
8. Veg: 🌽🥕🍅/🥦🧅🥔
9. Bread: 🍞🥖🥯/🥨🥐🥞
10. Vehicle: 🌭🍔🌮/🍕🥪🌯
11. Dessert: 🍬🍰🍫/🍭🍦🍩
12. Flower: 🌼🌸🌺/🌻🌷🌹
13. Celestial: ☀️🌙🌏/☄️🪐🚀
14. Powers: 🔮🧹👻/✨🍄👾
15. Tech: 🪨📄✂️/💣🛸☂️
16. Media: 📼💿💾/📁🗄🗑
17. Biome: 🌳🏔🏜/🏝🌋🖼
18. Voice: 💭💬🗯/❔🌀💤
19. Investing: 📈📉📊/♻️🛢💎
20. Element: 🌿🔥💧/🌈⚡️☢️


Token🪐
Name
Birthday/sign♍️
Litter
Pets counter
Mood
Relationships
Parents
Trades

'''
