require "blockspring/cli/command/base"

# huh?
#
class Blockspring::CLI::Command::Help < Blockspring::CLI::Command::Base

  PRIMARY_NAMESPACES = %w( auth block run )

  def index
    if command = args.shift
      help_for_command(command)
    else
      help_for_root
    end
  end

  private

  def help_for_root
    puts "Usage: blockspring COMMAND [command-specific-options]"
    puts
    puts "Primary help topics, type \"blockspring help TOPIC\" for more details:"
    puts
    summary_for_namespaces(primary_namespaces)
    puts
    puts "Additional topics:"
    puts
    summary_for_namespaces(additional_namespaces)
    puts
  end

  def commands
    Blockspring::CLI::Command.commands
  end

  def help_for_command(name)
    if command_alias = Blockspring::CLI::Command.command_aliases[name]
      display("Alias: #{name} redirects to #{command_alias}")
      name = command_alias
    end
    if command = commands[name]
      puts "Usage: blockspring #{command[:banner]}"

      if command[:help].strip.length > 0
        help = command[:help].split("\n").reject do |line|
          line =~ /HIDDEN/
        end
        puts help[1..-1].join("\n")
      end
      puts
    end

    namespace_commands = commands_for_namespace(name).reject do |command|
      command[:help] =~ /DEPRECATED/
    end

    if !namespace_commands.empty?
      puts "Additional commands, type \"blockspring help COMMAND\" for more details:"
      puts
      help_for_namespace(name)
      puts
    elsif command.nil?
      error "#{name} is not a blockspring command. See `heroku help`."
    end
  end

  def commands_for_namespace(name)
    Blockspring::CLI::Command.commands.values.select do |command|
      command[:namespace] == name && command[:command] != name
    end
  end

  def help_for_namespace(name)
    namespace_commands = commands_for_namespace(name)

    unless namespace_commands.empty?
      size = longest(namespace_commands.map { |c| c[:banner] })
      namespace_commands.sort_by { |c| c[:banner].to_s }.each do |command|
        next if skip_command?(command)
        command[:summary] ||= ""
        puts "  %-#{size}s  # %s" % [ command[:banner], command[:summary] ]
      end
    end
  end

  def skip_namespace?(ns)
    return true if ns[:description] =~ /DEPRECATED:/
    return true if ns[:description] =~ /HIDDEN:/
    false
  end

  def skip_command?(command)
    return true if command[:help] =~ /DEPRECATED:/
    return true if command[:help] =~ /^ HIDDEN:/
    false
  end

  def namespaces
    namespaces = Blockspring::CLI::Command.namespaces
    namespaces
  end

  def primary_namespaces
    PRIMARY_NAMESPACES.map { |name| namespaces[name] }.compact
  end

  def additional_namespaces
    (namespaces.values - primary_namespaces)
  end

  def summary_for_namespaces(namespaces)
    size = longest(namespaces.map { |n| n[:name] })
    namespaces.sort_by {|namespace| namespace[:name]}.each do |namespace|
      next if skip_namespace?(namespace)
      name = namespace[:name]
      namespace[:description] ||= ""
      puts "  %-#{size}s  # %s" % [ name, namespace[:description] ]
    end
  end
end
