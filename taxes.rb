require 'csv'
require 'pry'

class Taxes

  attr_accessor :csv, :header_row

  def initialize(csv)
    @csv = csv
  end

  def columns
    %w(date unique_id transaction_type cheque_number payee memo amount)
  end

  def rows
    @rows ||= begin
      rows = CSV.parse(csv)
      self.header_row = rows.shift
      rows
    end
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

