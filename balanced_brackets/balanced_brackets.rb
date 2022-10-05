BRACKETS = { '(' => ')', '{' => '}', '[' => ']' }.freeze

OPENING_BRACKETS = BRACKETS.keys
CLOSING_BRACKETS = BRACKETS.values

def balanced?(string)
  stack = []
  string.each_char do |ch|
    if OPENING_BRACKETS.include?(ch)
      stack.push(ch)
    elsif CLOSING_BRACKETS.include?(ch)
      ch == BRACKETS[stack.last] ? stack.pop : (return false)
    end
  end
  stack.empty?
end

str = ''
while str.length < OPENING_BRACKETS.length + CLOSING_BRACKETS.length
  puts 'Put bracket: '
  input = $stdin.gets.chomp
  unless (OPENING_BRACKETS.include? input) || (CLOSING_BRACKETS.include? input)
    puts 'Invalid input'
    next
  end
  balanced?(str.concat(input)) ? (puts '-- Balanced!') : (puts '-- Not balanced.')
  puts "-- Current string: #{str}" unless str.empty?

end
