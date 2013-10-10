require 'forwardable'

class NumberGroup
  attr_reader :numbers

  extend Forwardable
  def_delegators :@numbers, :<<, :concat, :join, :length, :uniq, :sort

  def initialize line=''
    @numbers = []
    @numbers.concat line.scan(/\d|_/).map(&:to_i)
  end

  def valid?
    self.length == 9 && has_no_duplicate_numbers?
  end

  def solved?
    has_one_of_each_number?
  end

  def to_s
    self.join(' ').gsub('0', ' ').scan(/.{1,6}/).join("| ").concat(' |').prepend('| ')
  end

  def to_a
    @numbers
  end

  private

  def has_one_of_each_number?
    self.uniq.sort == (1..9).to_a
  end

  def has_no_duplicate_numbers?
    self.uniq.length == self.length
  end
end
