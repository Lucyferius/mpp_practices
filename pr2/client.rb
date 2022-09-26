require_relative 'calculator'

def start
    begin
        puts("gimme a: ")
        a = to_integer(gets.chomp)
        puts("gimme b: ")
        b = to_integer(gets.chomp)
        puts "gimme operation (allowed ones: +, -, *, / )"
        operation = gets.chomp

        result = SimpleCalculator.calculate(a,b,operation)
        puts "#{a} #{operation} #{b} = #{result}"

    rescue ArgumentError => ex
        puts "Check your input: #{ex.to_s}"
    rescue UnsupportedOperation => ex
        puts "Check the list of allowed operations: #{ex.to_s}"
    rescue => ex
        puts "Unexpected exception #{ex.to_s}"
    end

end

def to_integer(a)
    raise ArgumentError.new "argument isn't integer -- {#{a}}" unless a.to_i.to_s == a
    a.to_i
end

start