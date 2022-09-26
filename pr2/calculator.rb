class SimpleCalculator

  ALLOWED_OPERATIONS = %w[+ / * -]

  def self.calculate(a, b, operation)
    raise ArgumentError.new "invalid arguments, only integers are allowed" unless a.is_a?(Integer) && a.is_a?(Integer)
    raise UnsupportedOperation.new unless ALLOWED_OPERATIONS.include?(operation)
    a.public_send(operation, b)

  rescue ZeroDivisionError
     'division by zero is not allowed.'
  end

end

class UnsupportedOperation < StandardError
  def initialize(msg="unsupported calculating operation")
    super
  end
end