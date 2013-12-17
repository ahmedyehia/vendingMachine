require 'rubygems'
require 'mysql2'
require 'yaml'
require "./lib/ConnectorInterface.rb"

class MysqlDatabaseConnector < BasicConnectorInterface
  @config = YAML::load_file("config/database.yml")["development"]
  @@client = Mysql2::Client.new(@config)

  def self.find(id)
    id = @@client.escape("#{id}")
    records = @@client.query('SELECT * FROM ' + "#{self}s".downcase + " where id='#{id}'")
    to_object(records.first) if records.first
  end

  def update(args = instance_variables)
    query = 'UPDATE `' + "#{self.class}s".downcase + '` SET '
    args.each do |var|
      var = "#{var}".delete('@')
      value = send(var)
      if value.is_a? String
        query << "`#{var}`='#{value}',"
      else
        query << "`#{var}`=#{value},"
      end
    end
    query.chop!
    query << " WHERE `id`=#{id}"
    @@client.query(query);
  end

  def self.to_object(record)
    obj = new
    obj.instance_variables.each do |var|
      var = "#{var}".delete('@')
      value = record[var]
      obj.send("#{var}=", value)
    end
    obj
  end

  def self.all
    records = @@client.query('SELECT * FROM ' + "#{self}s".downcase)
    products = []
    records.each do |record|
      products << to_object(record)
    end
    products
  end
end