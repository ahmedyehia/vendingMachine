require "./lib/MysqlDatabaseConnector.rb"

# class to map opertaions on Change table
class Change < MysqlDatabaseConnector
  attr_accessor :id, :name, :value, :quantity

  def initialize(id =  nil, name =  nil, value =  nil, quantity =  nil)
      @id, @name, @value, @quantity = id, name, value, quantity
  end

  def withdrow(q)
    @quantity = @quantity - q
    update [:quantity]
  end

  def reload(q)
    if q > 0
      @quantity = @quantity + q
      update [:quantity]
      return true
    else
      return false
    end
  end

  def to_s
    "#{id} => #{name}, #{value}, #{quantity}"
  end

  def check(reminder)
    arr = reminder.divmod(@value)
    quotient = arr[0]
    modulus = arr[1].round(2)
    if @quantity >= quotient
      return { enough: true, quotient: quotient, modulus: modulus }
    else
      return { enough: false, quotient: quotient, modulus: modulus }
    end
  end
end
