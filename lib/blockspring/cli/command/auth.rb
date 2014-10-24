require "blockspring/cli/command/base"

# authentication (login, logout)
#
class Blockspring::CLI::Command::Auth < Blockspring::CLI::Command::Base

  # auth
  #
  # Authenticate, display current user
  def index
    user, _key = Blockspring::CLI::Auth.get_credentials
    if user
      puts "You are logged in as #{user}"
    end
  end

  # auth:login
  #
  # log in with your blockspring credentials
  #
  #Example:
  #
  # $ blockspring auth:login
  # Enter your Blockspring credentials:
  # Username or email: email@example.com
  # Password (typing will be hidden):
  # You are logged in as example
  #
  def login
    user, _key = Blockspring::CLI::Auth.reauthorize
    if user
      puts "You are logged in as #{user}"
    end
  end

  # auth:logout
  #
  # clear your blockspring credentials
  #
  #Example:
  #
  # $ blockspring auth:logout
  #
  def logout
    Blockspring::CLI::Auth.delete_credentials
    puts "You have been logged out"
  end

  alias_command 'login', 'auth:login'
  alias_command 'logout', 'auth:logout'
end
