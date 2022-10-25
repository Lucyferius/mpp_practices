class StringScannerUtils

  # examples
  #   "88 90 99 88 ! !???" -> empty hash
  #   "I don't care. I love it. I don't care..." -> ["i" -> 3], ["don't" -> 2], ["care" -> 2]....
  def self.scan_frequent_words (input)
    result = Hash.new
    split = input.downcase.scan(/[A-z']+/)
    split.each do |word|
      if result.key? word
        result[word] += 1
      else result[word] = 1
      end
    end
    result.sort_by {|k,v| v}.reverse
  end

  def self.get_input
    puts "Write text ... (press Enter twice to end typing)"
    $/ = "\n\n"
    STDIN.gets
  end

end

input = StringScannerUtils.get_input
words_hash = StringScannerUtils.scan_frequent_words input
if words_hash.empty?
  puts "Text doesn't contain any words (whitespace, numbers and punctuation signs are ignored)."
else
  puts "\nTop results ..."
  words_hash[0..2].each { |k,v| puts "Word {#{k}} -> #{v} times" }
end


