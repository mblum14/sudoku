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
      row.each do |number|
        next if number.zero?
        
      end
    end
  end

end
