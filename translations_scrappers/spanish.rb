require 'mechanize'

module SpanishTranslationScrapper
  def self.scrape
    sewar_names = [ "al-Fatihah", "al-Baqarah", "Al-Imran", "an-Nisa'", "al-Ma'idah", 
                   "al-An`am", "al-A`raf", "al-Anfal", "at-Taubah", "Yunus", "Hud", 
                   "Yusuf", "ar-Ra`d", "Ibrahim", "al-Hijr", "an-Nahl", "bani Isra'il", 
                   "al-Kahf", "Maryam", "Ta Ha", "al-Anbiya'", "al-Hajj", "al-Mu'minun", 
                   "an-Nur", "al-Furqan", "ash-Shu`ara'", "an-Naml", "al-Qasas", "al-`Ankabut",
                   "ar-Rum", "Luqman", "as-Sajdah", "al-Ahzab", "Saba'", "al-Fatir", "Ya Sin",
                   "as-Saffat", "Sad", "az-Zumar", "al-Mu'min", "Ha Mim Sajdah", "ash-Shura", 
                   "az-Zukhruf", "ad-Dukhan", "al-Jathiyah", "al-Ahqaf", "Muhammad", "al-Fath", 
                   "al-Hujurat", "Qaf", "adh-Dhariyat", "at-Tur", "an-Najm", "al-Qamar", "ar-Rahman",
                   "al-Waqi`ah", "al-Hadid", "al-Mujadilah", "al-Hashr", "al-Mumtahanah", "as-Saff",
                   "al-Jum`ah", "al-Munafiqun", "at-Taghabun", "at-Talaq", "at-Tahrim", "al-Mulk", 
                   "al-Qalam", "al-Haqqah", "al-Ma`arij", "Nuh", "al-Jinn", "al-Muzammil", "al-Mudathir",
                   "al-Qiyamah", "ad-Dahr", "al-Mursalat", "an-Naba'", "an-Nazi`at", "`Abasa", "at-Takwir", "al-Infitar",
                   "at-Tatfif", "al-Inshiqaq", "al-Buruj", "at-Tariq", "al-A`la", "al-Ghashiyah", "al-Fajr", 
                   "al-Balad", "ash-Shams", "al-Layl", "ad-Duha", "al-Inshirah", "at-Tin", "al-`Alaq", "Qadr", 
                   "al-Bayyinah", "al-Zilzal", "al-`Adiyat", "al-Qari`ah", "at-Takathur", "al-`Asr", "al-Humazah", 
                   "al-Fil", "al-Quraysh", "al-Ma`un", "al-Kauthar", "al-Kafirun", "an-Nasr", "al-Lahab", 
                   "al-Ikhlas", "al-Falaq", "an-Nas" ]
                         
    mosshaf = File.new('mosshaf.txt', 'w+') 
    agent = Mechanize.new
    sura_no = 1
    verse_no = 1
    
    while sura_no < 115
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
  end
end