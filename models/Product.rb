require "./lib/MysqlDatabaseConnector.rb"

# class to map opertaions on Product table
class Product < MysqlDatabaseConnector
  attr_accessor :id, :name, :price, :quantity

  def initialize(id = nil, name =  nil, price =  nil, quantity =  nil)
      @id, @name, @price, @quantity = id, name, price, quantity
  end

  def buyOne
    @quantity = @quantity - 1
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
    "#{id} => #{name} , #{price} , #{quantity}"
  end
end
