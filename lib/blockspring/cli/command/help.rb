require "blockspring/cli/command/base"

class Blockspring::CLI::Command::Help < Blockspring::CLI::Command::Base
  def index
    puts "Usage: blockspring COMMAND [options]"
    puts
    puts "More info at http://www.blockspring.com/documentation/cli"
  end
end
