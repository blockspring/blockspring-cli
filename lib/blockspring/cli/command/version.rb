require "blockspring/cli/command/base"

# display version
#
class Blockspring::CLI::Command::Version < Blockspring::CLI::Command::Base

  # version
  #
  # show blockspring command line tool version
  #
  #Example:
  #
  # blockspring version
  # blockspring-cli-gem/1.0.4 (x86_64-darwin13.0) ruby/2.1.2
  def index
    puts Blockspring::CLI.user_agent
  end
end
