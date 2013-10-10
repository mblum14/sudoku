unless defined? NumberGroup
  require File.join(File.dirname(__FILE__), 'number_group')
end

class Board
  attr_reader :rows, :columns, :squares

  def initialize board_file
    @rows = []
    board_file.each do |line|
      next unless line =~ /\d|_/
      @rows << NumberGroup.new(line)
      unless @rows.last.valid?
        $stderr.puts "ERROR - Invalid board row detected: #{line.chomp}"
        exit 2
      end
    end
  end

  def columns
    rows.map(&:numbers).transpose
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

end
