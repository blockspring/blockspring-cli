require "blockspring/cli/command/base"

class Blockspring::CLI::Command::Auth < Blockspring::CLI::Command::Base
  def index
    user, _key = Blockspring::CLI::Auth.get_credentials
    if user
      puts "You are logged in as #{user}"
    end
  end

  def login
    Blockspring::CLI::Auth.reauthorize
  end

  def logout
    Blockspring::CLI::Auth.delete_credentials
    puts "You have been logged out"
  end
end
