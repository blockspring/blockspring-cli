require "blockspring/cli/command/base"

class Blockspring::CLI::Command::Auth < Blockspring::CLI::Command::Base
  def index
    user, _key = Blockspring::CLI::Auth.get_credentials
    if user
      puts "You are logged in as #{user}"
    end
  end

  def login
    user, _key = Blockspring::CLI::Auth.reauthorize
    if user
      puts "You are logged in as #{user}"
    end
  end

  def logout
    Blockspring::CLI::Auth.delete_credentials
    puts "You have been logged out"
  end

  alias_command 'login', 'auth:login'
  alias_command 'logout', 'auth:logout'
end
