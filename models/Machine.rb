require "./lib/MysqlDatabaseConnector.rb"

# class to map opertaions on Machine table
class Machine < MysqlDatabaseConnector
  attr_accessor :id, :name, :money

  def initialize(id = nil, name = nil, money = nil)
      @id, @name, @money = id, name, money
  end

  # assume that all products on database belongs to one machine
  def products
    Product.all
  end

  # assume that all change on database belongs to one machine
  def changes
    Change.all.sort! { |a, b| b.value <=> a.value }
  end

  def addMoney(m)
    @money = @money + m
    update [:money]
  end

  def to_s
    "#{id}, #{name}, #{money}"
  end
end
