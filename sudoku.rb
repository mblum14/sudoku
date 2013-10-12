require 'bundler'
Bundler.require
require File.join(File.dirname(__FILE__), 'lib', 'board')

def usage message
    $stderr.puts(message)
    $stderr.puts("Usage: #{File.basename($0)}: <FILE>")
    exit 2
end

if ARGV[0]
  board_file = ARGV.shift
else
  usage("Provide a board file")
end

if board_file
  board = Board.new(File.open(board_file))
  board.solve!
end
