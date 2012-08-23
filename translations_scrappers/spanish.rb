require 'mechanize'

module SpanishTranslationScrapper
  def self.scrape
    sewar_names = [ "Al-Fatihah", "al-Baqarah", "Al-Imran", "An-Nisa'", "Al-Ma'idah", 
                   "Al-An`am", "Al-A`raf", "Al-Anfal", "At-Taubah", "Yunus", "Hud", 
                   "Yusuf", "Ar-Ra`d", "Ibrahim", "Al-Hijr", "An-Nahl", "Al-Israa", 
                   "Al-Kahf", "Maryam", "TaHa", "Al-Anbiya'", "Al-Hajj", "Al-Mu'minun", 
                   "An-Nur", "Al-Furqan", "Ash-Shu`ara'", "An-Naml", "Al-Qasas", "Al-`Ankabut",
                   "Ar-Rum", "Luqman", "As-Sajdah", "Al-Ahzab", "Saba'", "Fatir", "Yasin",
                   "As-Saffat", "Sad", "Az-Zumar", "Ghafer", "Foselat", "Ash-Shura", 
                   "Az-Zukhruf", "Ad-Dukhan", "Al-Jathiyah", "Al-Ahqaf", "Muhammad", "Al-Fath", 
                   "Al-Hujurat", "Qaf", "Adh-Dhariyat", "At-Tur", "An-Najm", "Al-Qamar", "Ar-Rahman",
                   "Al-Waqi`ah", "Al-Hadid", "Al-Mujadilah", "Al-Hashr", "Al-Mumtahanah", "As-Saff",
                   "Al-Jum`ah", "Al-Munafiqun", "At-Taghabun", "At-Talaq", "At-Tahrim", "Al-Mulk", 
                   "Al-Qalam", "Al-Haqqah", "Al-Ma`arij", "Nuh", "Al-Jinn", "Al-Muzammil", "Al-Mudathir",
                   "Al-Qiyamah", "Ad-Dahr", "Al-Mursalat", "An-Naba'", "An-Nazi`at", "`Abasa", "Al-Takwir", "Al-Infitar",
                   "At-Motafefeen", "Al-Inshiqaq", "Al-Buruj", "At-Tariq", "Al-A`la", "Al-Ghashiyah", "Al-Fajr", 
                   "Al-Balad", "Ash-Shams", "Al-Layl", "Ad-Duha", "Al-Inshirah", "At-Tin", "Al-`Alaq", "Qadr", 
                   "Al-Bayyinah", "Az-Zilzal", "Al-`Adiyat", "Al-Qari`ah", "At-Takathur", "Al-`Asr", "Al-Humazah", 
                   "Al-Fil", "Quraysh", "Al-Ma`un", "Al-Kauthar", "Al-Kafirun", "An-Nasr", "Al-Lahab", 
                   "Al-Ikhlas", "Al-Falaq", "An-Nas" ]
                         
    mosshaf = File.new('mosshaf.txt', 'w+') 
    agent = Mechanize.new
    sura_no = 1
    verse_no = 1
    
    while sura_no <= sewar_names.length 
      # Action is the language for example sp is the Spanish
      url = "http://www.mosshaf.com/web/ajax_trgma.php?ShowByVerseNo=1&SuraNo=#{sura_no}&VerseNo=#{verse_no}&Action=sp"
      page = agent.get(url).parser
      
      mosshaf.puts("----------------------#{sewar_names[sura_no - 1]}----------------------") if verse_no == 1
      
      unless page.at_css('span').text.unpack('C*').pack('U*').gsub(/[^0-9]/, '')=~ /^0$/
        page.css('span').each do |aya| 
          
          # Multiple sewars in the same page
          if aya.text.unpack('C*').pack('U*').gsub(/[^0-9]/, '') =~ /^1$/ && aya.text !=  page.at_css('span').text 
            sura_no += 1
            mosshaf.puts("----------------------#{sewar_names[sura_no - 1]}----------------------")
          end
           
          mosshaf.puts(aya.text)
        end
        
        verse_no = page.css('span').last.text.match(/(\d+)/).to_s.to_i + 1 # First Aya in the next page
      else
        sura_no += 1
        verse_no = 1
      end
    end
        
    mosshaf.close
  end
end