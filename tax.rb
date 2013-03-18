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
File.open("#{File.dirname(__FILE__)}/income.txt", 'w+') do |f|
  f.puts "====== #{t.income.length} Income =====\n"
  t.income.group_by(:payee).each do |key, values|
    f.puts "==== #{values.length} entries for #{key}"
    values.each{|v| f.puts v}
  end

  subtotal = t.income.map{|e| e[:amount]}.inject(&:+)
  f.puts "\nTotal\n#{subtotal.round(2)}"
end
File.open("#{File.dirname(__FILE__)}/expenses.txt", 'w+') do |f|
  f.puts "\n===== #{t.expenses.length} Expenses =====\n"
  t.expenses.group_by(:payee).each do |key, values|
    f.puts "==== #{values.length} entries for #{key}"
    values.each{|v| f.puts v}
  end

  f.puts "\nTotal\n#{t.expenses.map{|e| e[:amount]}.inject(&:+).round(2)}"
end
