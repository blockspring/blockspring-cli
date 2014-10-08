require "blockspring/cli/command/base"

class Blockspring::CLI::Command::Block < Blockspring::CLI::Command::Base
  def get
    block = get_block(@args[0])

    dir_name = create_block_directory(block)

    save_block_files(block, dir_name)

    puts "Done."
  end

  def pull
    # load config file
    config_text = File.read('blockspring.json')
    config_json = JSON.parse(config_text)
    # TODO: ensure valid config
    puts "Pulling #{config_json['user']}/#{config_json['id']}"
    block = get_block(config_json['id'])
    save_block_files(block, '.')
    puts "Done."
  end

  def push
    config_text = File.read('blockspring.json')
    config_json = JSON.parse(config_text)
    # TODO: check for language
    script_file = "block.#{config_json['language']}"
    puts "Reading #{script_file}"
  end

  alias_command "get",  "block:get"
  alias_command "pull", "block:pull"
  alias_command "push", "block:push"

protected

  # TODO: move this to another file like 'api'
  def get_block(block_id)
    _user, key = Blockspring::CLI::Auth.get_credentials
    response = RestClient.get "#{Blockspring::CLI::Auth.base_url}/cli/blocks/#{block_id}", params: { api_key: key }, user_agent: Blockspring::CLI.user_agent
    JSON.parse(response.to_str)
  end

  def create_block_directory(block)

    dir_name = get_block_directory(block)

    if File.exist?(dir_name) || File.symlink?(dir_name)
      return puts 'Block directory already exists.'
    end

    # create block directory
    puts "Creating directory #{dir_name}"
    Dir.mkdir(dir_name)
    dir_name
  end

  def get_block_directory(block)
    slug = block['config']['title'].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')[0,12]
    "#{slug}-#{block['id'][0,8]}"
  end

  def save_block_files(block, dir_name)
    # create script file
    script_file = File.join(dir_name, "block.#{block['config']['language']}")
    puts "Saving script file #{script_file}"
    File.open(script_file, 'w') { |file| file.write(block['code']) }

    # create config file
    config_file = File.join(dir_name, "blockspring.json")
    puts "Saving config file #{config_file}"
    File.open(config_file, 'w') { |file| file.write(JSON.pretty_generate(block['config']) + "\n") }
  end
end
