require 'active_support/core_ext/string'
require 'csv'
require 'forwardable'
require_relative 'filters'
require_relative 'filtered'

class Tax
  extend Forwardable
  def_delegators :table, :headers

  attr_accessor :path

  def initialize(path)
    @path = path
  end

  def table
    @table ||= CSV.table(path)
  end

  def filter(column)
    @filter_blank_memos ||= Filtered.new(table.class.new table.reject { |row|
      row[column].blank? || FILTERS.any? {|filter| row[column] =~ Regexp.new(filter) }
    })
  end
end

taxes = Tax.new File.expand_path("~/taxes.csv")
t = taxes.filter(:memo)
puts "====== #{t.income.length} Income =====\n"
t.income.group_by(:memo, :first_split_with => ' ').each do |key, values|
  puts "==== #{values.length} entries for #{key}"
  values.each(&method(:puts))
end
puts "\n===== #{t.expenses.length} Expenses =====\n"
t.expenses.group_by(:memo, :first_split_with => ' ').each do |key, values|
  puts "==== #{values.length} entries for #{key}"
  values.each(&method(:puts))
end

require 'pry'
binding.pry
