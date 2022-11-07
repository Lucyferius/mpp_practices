require_relative 'Calculator'
convertor = Convertor.new

['((10 / 2) /2) / (3+2)',
 '5 * (9 + 3)',
 'cos(10+1)',
 '19^2',
 '(2 * 8 + (2 * (3 + 1)))'].each do |expression|
  converted = convertor.present_in_polish_notation expression
  puts expression + "  =>  " + converted + "  result = " + "#{convertor.calculate converted}\n\n"
end
