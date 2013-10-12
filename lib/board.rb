unless defined? Row
  require File.join(File.dirname(__FILE__), 'row')
end

class Board
  attr_reader :rows

  def initialize board_file
    @rows = []
    board_file.each do |line|
      next unless line =~ /\d|_/
      @rows << Row.new(line)
      unless @rows.last.valid?
        $stderr.puts "ERROR - Invalid board row detected: #{line.chomp}"
        exit 2
      end
    end
  end

  def columns
    @rows.map(&:numbers).transpose
  end

  def solve!
    begin
      next!
      system('clear')
      puts self
      sleep(0.1)
    end until solved?
  end

  def solved?
    rows.select(&:solved?).length == 9
  end

  def to_s
    <<-BOARD
#{divider}
#{rows[0]}
#{rows[1]}
#{rows[2]}
#{divider}
#{rows[3]}
#{rows[4]}
#{rows[5]}
#{divider}
#{rows[6]}
#{rows[7]}
#{rows[8]}
#{divider}
    BOARD
  end

  private

  def divider
    "+-------+-------+-------+"
  end

  def next!
    rows.each_with_index do |row, row_idx|
      next if row.solved?
      row.each_with_index do |number, col_idx|
        next unless number.zero?
        next unless solution = solve_number(row_idx, col_idx)
        return row[col_idx] = solution
      end
    end
  end

  def solve_number row_idx, col_idx
    missing_numbers = @rows[row_idx].missing_numbers
    return missing_numbers.first if missing_numbers.length == 1
    missing_numbers.each do |number|
      next if column_at(col_idx).include? number
      next if box_at(row_idx, col_idx).include? number
      # can number be put anywhere else in this row?
      results = []
      @rows[row_idx].each_with_index do |val, col|
        next unless val.zero?
        next if col == col_idx
        results << (column_at(col).include?(number) || box_at(row_idx, col).include?(number))
      end
      next if results.index(false)
      return number
    end

    missing_numbers = (1..9).to_a - column_at(col_idx)
    return missing_numbers.first if missing_numbers.length == 1
    missing_numbers.each do |number|
      # can number be put anywhere else in this row?
      results = []
      column_at(col_idx).each_with_index do |val, row|
        next unless val.zero?
        next if row == row_idx
        results << (@rows[row].include?(number) || box_at(row, col_idx).include?(number))
      end
      next if results.index(false)
      return number
    end
    nil
  end

  def column_at col_idx
    columns[col_idx]
  end

  def box_at row_idx, col_idx
    box_mapping = [
      [0, 0, 0, 1, 1, 1, 2, 2, 2], [0, 0, 0, 1, 1, 1, 2, 2, 2], [0, 0, 0, 1, 1, 1, 2, 2, 2],
      [3, 3, 3, 4, 4, 4, 5, 5, 5], [3, 3, 3, 4, 4, 4, 5, 5, 5], [3, 3, 3, 4, 4, 4, 5, 5, 5],
      [6, 6, 6, 7, 7, 7, 8, 8, 8], [6, 6, 6, 7, 7, 7, 8, 8, 8], [6, 6, 6, 7, 7, 7, 8, 8, 8]
    ]
    box_indices = {
      '0' => [(0..2), (0..2)], '1' => [(0..2), (3..5)], '2' => [(0..2), (6..8)],
      '3' => [(3..5), (0..2)], '4' => [(3..5), (3..5)], '5' => [(3..5), (6..8)],
      '6' => [(6..8), (0..2)], '7' => [(6..8), (3..5)], '8' => [(6..8), (6..8)]
    }
    box_number = box_mapping[row_idx][col_idx]
    box = []
    row_range, col_range = box_indices[box_number.to_s]
    row_range.each do |row|
      box += @rows[row][col_range]
    end
    box
  end
end
