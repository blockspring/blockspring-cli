require "blockspring/cli/command/base"

# manipulate blocks (get, push, pull, new)
#
class Blockspring::CLI::Command::Block < Blockspring::CLI::Command::Base
  # block:get BLOCKID
  #
  # pull down an existing block from blockspring
  #
  #Example:
  #
  # $ blockspring get testuser/f19512619b94678ea0b4bf383f3a9cf5
  # Creating directory cool-block-f1951261
  # Syncing script file cool-block-f1951261/block.py
  # Syncing config file cool-block-f1951261/blockspring.json
  # Done.
  #
  def get
    block_parts = @args[0].split("/")
    block = get_block(block_parts[block_parts.length - 1])

    dir_name = create_block_directory(block)

    if dir_name
      save_block_files(block, dir_name)
      puts "Done."
    end

  end

  # block:pull
  #
  # pull block changes from the server to current directory
  #
  #Example:
  #
  # $ blockspring pull
  # Syncing script file block.py
  # Syncing config file blockspring.json
  # Done.
  #
  def pull
    # load config file
    config_text = File.read('blockspring.json')
    config_json = JSON.parse(config_text)
    # TODO: ensure valid config
    puts "Pulling #{config_json['user']}/#{config_json['id']}"
    block = get_block(config_json['id'])
    save_block_files(block, '.', 'Pulling')
    puts "Done."
  end

  # block:push
  #
  # push local block changes or new block to the server
  #
  #Example:
  #
  # $ blockspring push
  # Syncing script file block.py
  # Syncing config file blockspring.json
  # Done.
  #
  def push
    _user, key = Blockspring::CLI::Auth.get_credentials
    config_text = File.read('blockspring.json')
    config_json = JSON.parse(config_text)
    # TODO: check for language
    # language could eventually be js:0.10.x or py:3 or ruby:MRI-2.0
    script_file = "block.#{config_json['language'].split(':')[0]}"
    script = File.read(script_file)

    payload = {
      code: script,
      config: config_json
    }

    if @args.include? '--force'
      payload['force'] = true
    end

    if config_json['id']
      uri = "#{Blockspring::CLI::Auth.base_url}/cli/blocks/#{config_json['id']}"
    else
      uri = "#{Blockspring::CLI::Auth.base_url}/cli/blocks"
    end

    begin
      response = RestClient.post uri, payload.to_json, :content_type => :json, :accept => :json, params: { api_key: key }, user_agent: Blockspring::CLI.user_agent
      json_response = JSON.parse(response.body)
      save_block_files(json_response, '.', 'Syncronizing')
    rescue RestClient::Exception => msg
      error(msg.inspect)
    end
  end

  # block:new LANGUAGE "Block Name"
  #
  # generate a new block
  #
  # LANGUAGE: js|php|py|R|rb
  #
  #Example:
  #
  # $ blockspring new js "My Cool Block"
  # Creating directory my-cool-block
  # Syncing script file my-cool-block/block.js
  # Syncing config file my-cool-block/blockspring.json
  #
  def new
    user, key = Blockspring::CLI::Auth.get_credentials
    language = @args[0]
    name = @args[1]

    begin

      block = get_template(language)

      block['config']['title'] = name

      dir_name = create_block_directory(block)
      if dir_name
        save_block_files(block, dir_name, 'Creating')
      end
    rescue RestClient::ResourceNotFound => msg
      error("The language '#{language}' is not supported by Blockspring.")
    rescue RestClient::Exception => msg
      error(msg.inspect)
    end
  end

  alias_command "get",  "block:get"
  alias_command "pull", "block:pull"
  alias_command "push", "block:push"
  alias_command "new", "block:new"

protected

  # TODO: move this to another file like 'api'
  def get_block(block_id)
    _user, key = Blockspring::CLI::Auth.get_credentials
    response = RestClient.get "#{Blockspring::CLI::Auth.base_url}/cli/blocks/#{block_id}", params: { api_key: key }, user_agent: Blockspring::CLI.user_agent
    JSON.parse(response.to_str)
  end

  def get_template(format)
    _user, key = Blockspring::CLI::Auth.get_credentials
    response = RestClient.get "#{Blockspring::CLI::Auth.base_url}/cli/templates/#{format}", params: { api_key: key }, user_agent: Blockspring::CLI.user_agent
    JSON.parse(response.to_str)
  end

  def create_block_directory(block)

    dir_name = get_block_directory(block)

    if File.exist?(dir_name) || File.symlink?(dir_name)
      puts 'Block directory already exists.'
      return false
    end

    # create block directory
    puts "Creating directory #{dir_name}"
    Dir.mkdir(dir_name)
    dir_name
  end

  def get_block_directory(block)
    slug = block['config']['title'].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
    if block['config']['id']
      "#{slug[0,12]}-#{block['id'][0,8]}"
    else
      "#{slug[0,20]}"
    end
  end

  def save_block_script(block, dir_name, action='Syncing')
    script_file = File.join(dir_name, "block.#{block['config']['language'].split(':')[0]}")
    puts "#{action} script file #{script_file}"
    File.open(script_file, 'w') { |file| file.write(block['code']) }
  end

  def save_block_config(block, dir_name, action='Syncing')
    config_file = File.join(dir_name, "blockspring.json")
    puts "#{action} config file #{config_file}"
    File.open(config_file, 'w') { |file| file.write(JSON.pretty_generate(block['config']) + "\n") }
  end

  def save_block_files(block, dir_name, action='Syncing')
    # create script file
    save_block_script(block, dir_name, action)
    # create config file
    save_block_config(block, dir_name, action)
  end
end
