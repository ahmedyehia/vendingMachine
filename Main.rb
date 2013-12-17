require "./models/Machine"
require "./models/Change.rb"
require "./models/Product.rb"
# this the main class that handle the logic for manipulating the objects and displaying results for user
class Main
  # assume that we are working on machine 1
  @machine = Machine.find(1)
  @actions = { 1 => 'buy product', 2 => 'reload product', 3 => 'reload change', 0 => 'to Exit' }
  @action_handlers = { 0 => 'byeBye', 1 => 'buyHandler', 2 => 'reloadProductHandler', 3 => 'reloadChange' }

  def self.start
     puts '_______________________ Welcome _______________________ '
    loop do
      @actions.each { |key, value| puts "#{key} : #{value}" }
      puts 'please enter operation code : '
      input = gets.chomp.to_i
      method = @action_handlers[input] || 'wroungInput'
      send(method)
      break if input == 0
    end
  end

  def self.wroungInput
    puts 'sorry error accured ,please enter a valid numper'
  end

  def self.byeBye
    puts 'Birdie num num bye bye partner :D'
  end

  def self.buyHandler
    loop do
      puts '_______________________ products _______________________ '
      puts @machine.products
      puts '0 => to exit'
      puts 'please enter products code you want to reload'
      input = gets.chomp.to_i
      break if input == 0
      product = Product.find(input)
      if product
        if product.quantity == 0
          puts 'sorry product out of stock'
        else
          puts 'please enter your cash'
          cash = gets.chomp.to_f
          if (cash > 0.0)
            changeRequired = cash - product.price
            if changeRequired >= 0.0
              changeToUser = buyOperation(product, cash, changeRequired.round(2))
              if changeToUser
                printChange(changeToUser)
              else
                puts 'sorry change not enough'
              end
            else
              puts 'sorry but the cash you enterted not enough'
            end
          else
            puts 'sorry cash must be larger than zero'
          end
        end
      else
        wroungInput
      end
    end
  end

  def self.printChange(changeHash)
    print 'your change is '
    total = 0
    changeHash.each do |key, value|
      change = Change.find(key)
      print " #{value} #{change.name} ,"
      total += (value * change.value)
      change.withdrow(value)
    end
    puts "total #{total} thank you"
  end

  def self.buyOperation(product, cash, changeRequired)
    changeToUser = {}
    @machine.changes.each do |change|
      changeRequired = changeRequired.round(2)
      changeState = change.check(changeRequired)
      if changeState[:enough]
        if changeState[:modulus] == 0
          changeToUser[change.id] = changeState[:quotient]
          @machine.addMoney(product.price)
          product.buyOne
          return changeToUser
        else
          if changeState[:quotient] != 0
            changeRequired = changeRequired - (changeState[:quotient] * change.value)
            changeToUser[change.id] = changeState[:quotient]
          end
        end
      else
        if change.quantity != 0
          changeRequired = changeRequired - (change.quantity * change.value)
          changeToUser[change.id] = change.quantity
        end
      end
    end
    return nil
  end
  def self.reloadProductHandler
    loop do
      puts '_______________________ products _______________________ '
      puts @machine.products
      puts '0 => to exit'
      puts 'please enter products code you want to reload'
      input = gets.chomp.to_i
      break if input == 0
      product = Product.find(input)
      if product
        puts 'please enter the quantity you want to enter'
        amount = gets.chomp.to_i
        puts product.reload(amount) ? 'quantity updated sucessfully' : 'quantitiy error'
      else
        wroungInput
      end
    end
  end

  def self.reloadChange
    loop do
      puts '_______________________ changes _______________________ '
      puts @machine.changes
      puts '0 => to exit'
      puts 'please enter change code you want to reload'
      input = gets.chomp.to_i
      break if input == 0
      change = Change.find(input)
      if change
        puts 'please enter the quantity you want to reload with : '
        amount = gets.chomp.to_i
        puts change.reload(amount) ? 'quantity updated sucessfully' : 'quantitiy error'
      else
        wroungInput
      end
    end
  end
end

Main.start
