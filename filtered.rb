require 'forwardable'

class Filtered
  extend Forwardable

  attr_accessor :table
  attr_reader :options
  def initialize(table, options = {})
    @table = table
    @options = {:amount => :amount}.merge(options)
  end

  def income
    self.class.new table.class.new(table.select{|t| t[options[:amount]] > 0 })
  end

  def expenses
    self.class.new table.class.new(table.select{|t| t[options[:amount]] < 0})
  end

  def group_by(field, options = {})
    if options[:filter]
      map.group_by {|row| row[field] =~ options[:filter] }
    elsif options[:first_split_with]
      map.group_by {|row| row[field].to_s.split(options[:first_split_with]).first}
    else
      map.group_by {|row| row[field] }
    end
  end

  def_delegators :table, :each, :map, :inject, :length
end
