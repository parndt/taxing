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
    @rows ||= CSV.parse(csv)
  end

  def matrix
    @matrix ||= rows.map do |row|
      columns.each_with_index.inject({}) do |hash, (title, index)|
        hash[title] = row[index]
        hash
      end
    end
  end

end

t = Taxes.new(File.read(File.expand_path("~/taxes.csv")))
binding.pry
