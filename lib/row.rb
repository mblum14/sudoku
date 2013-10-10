require 'forwardable'

class Row
  attr_reader :row

  extend Forwardable
  def_delegators :@row, :<<, :concat, :join, :length # and anything else

  def initialize line=''
    @row = []
    @row.concat line.scan(/\d|_/).map(&:to_i)
  end

  def valid?
    self.length == 9
  end

  def to_s
    self.join(' ').gsub('0', ' ').scan(/.{1,6}/).join("| ").concat(' |').prepend('| ')
  end
end
