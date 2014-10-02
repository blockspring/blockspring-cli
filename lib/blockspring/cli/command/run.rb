require "blockspring/cli/command/base"

class Blockspring::CLI::Command::Run < Blockspring::CLI::Command::Base
  def index
    if ENV['BLOCKSPRING_API_KEY'].to_s.strip.empty?
      _, key = Blockspring::CLI::Auth.get_credentials
      if key
        ENV['BLOCKSPRING_API_KEY'] = key
      end
    end

    # now run
    system('echo $BLOCKSPRING_API_KEY')
  end
end
