require 'csv'

class Taxes

  attr_accessor :path

  def initialize(path)
    @path = path
  end

  def columns
    %w(date unique_id transaction_type cheque_number payee memo amount)
  end

  def table
    @table ||= CSV.table(path)
  end

end

taxes = Taxes.new File.expand_path("~/taxes.csv")

require 'pry'
binding.pry
