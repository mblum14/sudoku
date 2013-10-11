require 'forwardable'

class Row
  attr_accessor :numbers

  extend Forwardable
  def_delegators :@numbers, :<<, :concat, :join, :length, :uniq, :sort, :reject, :each_with_index, :[]=

  def initialize line=''
    if line.kind_of?(::Array)
      @numbers = line
    else
      @numbers = []
      @numbers.concat line.scan(/\d|_/).map(&:to_i)
    end
  end

  def remaining_numbers
    (1..9).to_a - @numbers
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
    self.reject(&:zero?).uniq.length == self.reject(&:zero?).length
  end
end
