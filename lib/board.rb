unless defined? Row
  require File.join(File.dirname(__FILE__), 'sudoku', 'array')
end

class Board
  attr_reader :rows

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
  end

  def columns
    @rows.transpose
  end

  def boxes
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
    @boxes
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
      results = []
      column_at(col_idx).each_with_index do |val, row|
        next unless val.zero?
        next if row == row_idx
        results << (@rows[row].include?(number) || box_at(row, col_idx).include?(number))
      end
      next if results.index(false)
      return number
    end

    # Check by box
    missing_numbers = (1..9).to_a - box_at(row_idx, col_idx)
    return missing_numbers.first if missing_numbers.length == 1
    missing_numbers.each do |number|
      results = []
      box = box_at(row_idx, col_idx)
      box.each_with_index do |val, idx|
        next unless val.zero?
        next if box_idx_for(row_idx, col_idx) == idx
        results << (@rows[box_row_at(row_idx, idx)].include?(number) || column_at(box_col_at(col_idx, idx)).include?(number))
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
    box_number = box_mapping[row_idx][col_idx]
    boxes[box_number]
  end

  def box_idx_for row_idx, col_idx
    row_offset = case row_idx
                 when 0, 3, 6 then 0
                 when 1, 4, 7 then 3
                 else 6
                 end
    col_offset = case col_idx
                 when 0, 3, 6 then 0
                 when 1, 4, 7 then 1
                 else 2
                 end
    return row_offset + col_offset
  end

  def box_row_at row_idx, idx
    row_offset = case idx
                 when 0, 1, 2 then 0
                 when 3, 4, 5 then 1
                 else 2
                 end

    case row_idx
    when 0, 1, 2 then return 0 + row_offset
    when 3, 4, 5 then return 3 + row_offset
    else return 6 + row_offset
    end
  end

  def box_col_at col_idx, idx
    col_offset = case idx
                 when 0, 3, 6 then 0
                 when 1, 4, 7 then 1
                 else 2
                 end

    case col_idx
    when 0, 1, 2 then return 0 + col_offset
    when 3, 4, 5 then return 3 + col_offset
    else return 6 + col_offset
    end
  end
end
