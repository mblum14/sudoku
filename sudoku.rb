require 'bundler'
Bundler.require
require File.join(File.dirname(__FILE__), 'lib', 'board')

def usage message
    $stderr.puts(message)
    $stderr.puts("Usage: #{File.basename($0)}: [-f <FILE> ]")
    exit 2
end

board_file = 'board.txt'

loop do
  case ARGV[0]
  when '-f' then  ARGV.shift; board_file = ARGV.shift
  when /^-/ then  usage("Unknown option: #{ARGV[0].inspect}")
  else break
  end
end

if board_file
  board = Board.new(File.open(board_file))
  puts board
end
