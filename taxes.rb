require 'csv'
require 'forwardable'

class Taxes
  extend Forwardable
  def_delegators :table, :headers

  attr_accessor :path

  def initialize(path)
    @path = path
  end

  def table
    @table ||= CSV.table(path)
  end

end

taxes = Taxes.new File.expand_path("~/taxes.csv")

require 'pry'
binding.pry
