require "blockspring/cli/command/base"

class Blockspring::CLI::Command::Block < Blockspring::CLI::Command::Base
  def get
    _user, key = Blockspring::CLI::Auth.get_credentials
    response = RestClient.get "#{Blockspring::CLI::Auth.base_url}/cli/block/#{@args[0]}", params: { api_key: key }, user_agent: Blockspring::CLI.user_agent
    @block = JSON.parse(response.to_str)

    slug = @block['config']['title'].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')[0,12]

    dir_name = "#{slug}-#{@block['id'][0,8]}"

    if File.exist?(dir_name) || File.symlink?(dir_name)
      return puts 'Block directory already exists.'
    end

    # create block directory
    puts "Creating directory #{dir_name}"
    Dir.mkdir(dir_name)

    # create script file
    script_file = File.join(dir_name, "block.#{@block['config']['language']}")
    puts "Saving script file #{script_file}"
    File.open(script_file, 'w') { |file| file.write(@block['code']) }

    # create config file
    config_file = File.join(dir_name, "blockspring.json")
    puts "Saving config file #{config_file}"
    File.open(config_file, 'w') { |file| file.write(JSON.pretty_generate(@block['config']) + "\n") }

    puts "Done."
  end

  def pull
    # load config file
    config = File.read('blockspring.json')
  end

  def push

  end

  alias_command "get",  "block:get"
  alias_command "pull", "block:pull"
  alias_command "push", "block:push"
end
