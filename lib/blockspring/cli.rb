require 'netrc'
require 'rest_client'
require 'json'

require "blockspring/cli/version"
require "blockspring/cli/auth"
require "blockspring/cli/command"
require "blockspring/cli/helpers"

module Blockspring
  module CLI
    USER_AGENT = "blockspring-cli-gem/#{Blockspring::CLI::VERSION} (#{RUBY_PLATFORM}) ruby/#{RUBY_VERSION}"

    def self.user_agent
      @@user_agent ||= USER_AGENT
    end

    def self.user_agent=(agent)
      @@user_agent = agent
    end

    def self.start(*args)
      begin
        if $stdin.isatty
          $stdin.sync = true
        end
        if $stdout.isatty
          $stdout.sync = true
        end
        command = args.shift.strip rescue "help"
        Blockspring::CLI::Command.load
        Blockspring::CLI::Command.run(command, args)
      rescue Interrupt => e
        `stty icanon echo`
        if ENV["BLOCKSPRING_DEBUG"]
          puts e.inspect
        else
          error("Command cancelled.")
        end
      # rescue => error
      #   puts error.inspect
      #   exit(1)
      end
    end
  end
end
