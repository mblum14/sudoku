unless defined? Row
  require File.join(File.dirname(__FILE__), 'sudoku', 'array')
end

class Board
  attr_reader :rows, :columns, :boxes

  def initialize board_file
    @rows = []
    board_file.each do |line|
      next unless line =~ /\d|_/
      @rows << [].extend(Sudoku::Array).import_sudoku_line!(line)
      unless @rows.last.valid?
        $stderr.puts "ERROR - Invalid board row detected: #{line.chomp}"
        exit 2
      end
    end
    @columns = @rows.transpose
    box_indices = [ [(0..2), (0..2)], [(0..2), (3..5)], [(0..2), (6..8)],
                    [(3..5), (0..2)], [(3..5), (3..5)], [(3..5), (6..8)],
                    [(6..8), (0..2)], [(6..8), (3..5)], [(6..8), (6..8)] ]
    @boxes = []
    box_indices.each do |row_range, col_range|
      box = []
      row_range.each do |row|
        box += @rows[row][col_range]
      end
      @boxes << box
    end
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
    rows.each do |row|
      return false unless row.solved?
    end
    true
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
        row[col_idx] = solution
        column_at(col_idx)[row_idx] = solution
        box_at(row_idx, col_idx)[box_idx_for(row_idx, col_idx)] = solution
        return self
      end
    end
  end

  def solve_number row_idx, col_idx
    # Check by row
    missing_numbers = @rows[row_idx].missing_numbers
    return missing_numbers.first if missing_numbers.length == 1
    missing_numbers.each do |number|
      next if column_at(col_idx).include? number
      next if box_at(row_idx, col_idx).include? number
      results = []
      @rows[row_idx].each_with_index do |val, col|
        next unless val.zero?
        next if col == col_idx
        results << (column_at(col).include?(number) || box_at(row_idx, col).include?(number))
      end
      next if results.index(false)
      return number
    end

    # Check by column
    missing_numbers = (1..9).to_a - column_at(col_idx)
    return missing_numbers.first if missing_numbers.length == 1
    missing_numbers.each do |number|
      next if row_at(row_idx).include? number
      next if box_at(row_idx, col_idx).include? number
      results = []
      column_at(col_idx).each_with_index do |val, row|
        next unless val.zero?
        next if row == row_idx
        results << (row_at(row).include?(number) || box_at(row, col_idx).include?(number))
      end
      next if results.index(false)
      return number
    end

    # Check by box
    missing_numbers = (1..9).to_a - box_at(row_idx, col_idx)
    return missing_numbers.first if missing_numbers.length == 1
    missing_numbers.each do |number|
      next if row_at(row_idx).include? number
      next if column_at(col_idx).include? number
      posibilities = []
      box_at(row_idx, col_idx).each_with_index do |val, idx|
        next unless val.zero?
        posibilities << (row_rel_to(row_idx, idx).include?(number) || col_rel_to(col_idx, idx).include?(number))
      end
      next if posibilities.index(false)
      return number
    end
    nil
  end

  def column_at col_idx
    columns[col_idx]
  end

  def row_at row_idx
    rows[row_idx]
  end

  def box_at row_idx, col_idx
    boxes[box_idx_for(row_idx, col_idx)]
  end

  def box_idx_for row_idx, col_idx
    (row_idx - (row_idx % 3)) + (col_idx / 3)
  end

  def row_rel_to row_idx, box_idx
    row_offset = box_idx / 3
    @rows[(row_idx - (row_idx % 3)) + row_offset]
  end

  def col_rel_to col_idx, box_idx
    col_offset = (box_idx % 3) % 3
    column_at(((col_idx / 3) * 3) + col_offset)
  end
end
