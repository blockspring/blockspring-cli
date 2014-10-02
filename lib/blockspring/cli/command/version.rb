require "blockspring/cli/command/base"

class Blockspring::CLI::Command::Version < Blockspring::CLI::Command::Base
  def index
    puts Blockspring::CLI.user_agent
  end
end
