class Row
  attr_reader :row

  def initialize line
    @row = line.scan(/\d|_/).map(&:to_i)
  end

  def valid?
    row.length == 9
  end

  def to_s
    row.join(' ').gsub('0', ' ').scan(/.{1,6}/).join("| ").concat(' |').prepend('| ')
  end
end
