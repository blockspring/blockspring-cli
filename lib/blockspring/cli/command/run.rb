require "blockspring/cli/command/base"

# set BLOCKSPRING_API_KEY environment variable and run block
#
class Blockspring::CLI::Command::Run < Blockspring::CLI::Command::Base
  # run:local COMMAND
  #
  # set api key environment variable and run block
  #
  # Automatically detects if local or remote
  # Use run:local or run:remote to specify
  #
  #Example:
  #
  # $ blockspring run:local node block.js --zip-code=94110
  #
  def index
    if ENV['BLOCKSPRING_API_KEY'].to_s.strip.empty?
      _, key = Blockspring::CLI::Auth.get_credentials
      if key
        ENV['BLOCKSPRING_API_KEY'] = key
      end
    end

    match = /([^\/]+\/)([^\/]+)/.match(@args[0])

    if(match and not File.exist?(@args[0]))
      remote
    else
      local
    end
  end

  # run:local COMMAND
  #
  # set api key environment variable and run a local block
  #
  #Example:
  #
  # $ blockspring run:local node block.js --zip-code=94110
  #
  def local
    system(*@args)
  end

  # run:remote USER/BLOCKID
  #
  # set api key environment variable and run a remote block
  #
  # [--argname=value ...]   # specify arguments for the block
  #
  #Example:
  #
  # $ blockspring run:remote jtokoph/aasdfj332flk3 --zip-code=94110
  #
  def remote
    require 'blockspring'

    _, key = Blockspring::CLI::Auth.get_credentials

    block_id = @args[0]

    myBlock = lambda do |request, response|
      response = Blockspring.run(block_id, request.params, key)
      puts response
    end

    Blockspring.define(myBlock)
  end
end
