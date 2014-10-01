require "blockspring/cli/version"

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
        styled_error(e)
      else
        error("Command cancelled.")
      end
    rescue => error
      styled_error(error)
      exit(1)
    end
  end
  end
end
