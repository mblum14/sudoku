require 'bundler'
Bundler.require

def usage message
    $stderr.puts(message)
    $stderr.puts("Usage: #{File.basename($0)}: ")
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
end
