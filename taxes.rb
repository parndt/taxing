require 'csv'
require 'pry'

class Taxes

  attr_accessor :csv

  def initialize(csv)
    @csv = csv
  end

  def columns
    %w(date unique_id transaction_type cheque_number payee memo amount)
  end

  def rows
    @rows ||= CSV.parse(csv).freeze
  end

  def matrix
    @matrix ||= rows.map { |row|
      columns.each_with_index.inject(Hash.new) do |hash, (title, index)|
        hash[title] = row[index]
        hash
      end
    }.freeze
  end

end

t = Taxes.new(File.read(File.expand_path("~/taxes.csv")))
binding.pry
