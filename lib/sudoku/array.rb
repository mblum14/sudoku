require 'forwardable'

module Sudoku
  module Array

    def missing_numbers
      (1..9).to_a - self
    end

    def valid?
      self.length == 9 && has_no_duplicate_numbers?
    end

    def solved?
      has_one_of_each_number?
    end

    def import_sudoku_line!(line)
      self.concat line.scan(/\d|_/).map(&:to_i)
    end

    def to_s
      self.join(' ').gsub('0', ' ').scan(/.{1,6}/).join("| ").concat(' |').prepend('| ')
    end

    private

    def has_one_of_each_number?
      self.uniq.sort == (1..9).to_a
    end

    def has_no_duplicate_numbers?
      self.reject(&:zero?).uniq.length == self.reject(&:zero?).length
    end
  end
end
