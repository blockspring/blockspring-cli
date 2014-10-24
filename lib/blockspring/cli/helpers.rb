module Blockspring
  module CLI
    module Helpers

      def home_directory
        running_on_windows? ? ENV['USERPROFILE'].gsub("\\","/") : ENV['HOME']
      end

      def running_on_windows?
        RUBY_PLATFORM =~ /mswin32|mingw32/
      end

      def running_on_a_mac?
        RUBY_PLATFORM =~ /-darwin\d/
      end

      def display(msg="", new_line=true)
        if new_line
          puts(msg)
        else
          print(msg)
        end
        $stdout.flush
      end

      def longest(items)
        items.map { |i| i.to_s.length }.sort.last
      end

      def format_with_bang(message)
        return '' if message.to_s.strip == ""
        " !    " + message.split("\n").join("\n !    ")
      end

      def output_with_bang(message="", new_line=true)
        return if message.to_s.strip == ""
        display(format_with_bang(message), new_line)
      end

      def error(message)
        if Blockspring::CLI::Helpers.error_with_failure
          display("failed")
          Blockspring::CLI::Helpers.error_with_failure = false
        end
        $stderr.puts(format_with_bang(message))
        exit(1)
      end

      def self.error_with_failure
        @@error_with_failure ||= false
      end

      def self.error_with_failure=(new_error_with_failure)
        @@error_with_failure = new_error_with_failure
      end
    end
  end
end
