class Convertor
  TRIGONOMETRICAL = %w[cos sin tan cot]

  TRIGONOMETRICAL_SYMBOLS = TRIGONOMETRICAL.join.chars.uniq

  PRIORITY = {
    1 => %w[+ -],
    2 => %w[* /],
    3 => %w[^],
    4 => TRIGONOMETRICAL
  }

  SIMPLE_OPERATORS = %w[+ / * -]

  OperatorNode = Struct.new(:operand1, :operand2, :operator) do
    def concat
       if operator.strip == '^' || operator.strip == '/'  then return '(' + [operator, operand2, operand1].join('') + ')' end
       '(' + [operator, operand1, operand2].join('') + ')'
    end
  end

  def initialize
    @operators = []
    @operands = []
    @to_merge = false
    @trigonometric = ""
  end

  def present_in_polish_notation(str)
    initialize
    str.split(//).reject { |x| x == " " }.each { |symbol|
      case
      when symbol == "("
          process_open_bracket symbol
      when symbol == ")"
        process_closed_bracket
      when !operator?(symbol)
        process_digit symbol
      else
        if trigonometric?(symbol) then @trigonometric << symbol; next end
        process_operand symbol
      end
    }
    process_results
    @operands.last
  end

  def calculate(str)
    replacements = {'(' => '', ')' => ''}.
      tap { |h| h.default_proc = ->(h,k) { k } }
    stack = []
    str.gsub(/./, replacements).split(" ").reverse.each { |symbol|
      if digit?(symbol)
        stack.push(symbol.to_f)
      else
        operand1 = stack.pop.to_f
        if TRIGONOMETRICAL.include?symbol
          stack.push(process_trigonometrical symbol, operand1)
          next
        end
        operand2 = stack.pop.to_f
        if symbol == '^' then stack.push(operand1 ** operand2); next end
        if SIMPLE_OPERATORS.include? symbol then stack.push(operand1.public_send(symbol, operand2)); next end
        raise ArgumentError.new('Invalid argument passed')
      end
    }
    stack.pop
  end

  private
  def operator?(str)
    !digit? str
  end

  def digit?(str)
    str.match?(/\d/)
  end

  def trigonometric?(str)
    TRIGONOMETRICAL_SYMBOLS.include?str
  end

  def process_open_bracket(symbol)
    @operators << @trigonometric + " " unless @trigonometric.empty?
    @operators << symbol
    @trigonometric = ""
    @to_merge = false
  end

  def process_closed_bracket
    while @operators.length != 0 && @operators.last != "(" do
      process_expression
    end
    @operators.pop
    @to_merge = false
  end

  def process_expression
    node = OperatorNode.new(@operands.pop, @operands.pop, @operators.pop)
    @operands.push(node.concat)
  end

  def process_digit(symbol)
    @operands << @operands.pop.strip + symbol + " " if @to_merge
    @operands << symbol + " " unless @to_merge
    @to_merge = true
  end

  def process_operand(symbol)
    while @operators.length != 0 && get_priority(symbol.to_s) <= get_priority(@operators.last&.strip) do
      process_expression
    end
    @operators.push(symbol + " ")
    @to_merge = false
  end

  def get_priority(str)
    if str == "-" || str == "+" then return 1 end
    if str == "*" || str == "/" then return 2 end
    if str == "^" then return 3 end
    if TRIGONOMETRICAL.include?str then return 4 end
    0
  end

  def process_results
    while @operators.length != 0 do
      node = OperatorNode.new(@operands.pop, @operands.pop, @operators.pop)
      @operands.push(node.concat)
    end
  end

  def process_trigonometrical(symbol, operand1)
    if symbol == 'cot'
      1 / Math.tan(operand1)
    else
      Math.public_send(symbol,operand1)
    end
  end

end
