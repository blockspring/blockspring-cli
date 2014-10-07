class Blockspring::CLI::Command::Base
  attr_reader :args
  attr_reader :options

  def self.namespace
    self.to_s.split("::").last.downcase
  end

  def initialize(args=[], options={})
    @args = args
    @options = options
  end

  protected

  def self.method_added(method)
    return if self == Blockspring::CLI::Command::Base
    return if private_method_defined?(method)
    return if protected_method_defined?(method)

    resolved_method = (method.to_s == "index") ? nil : method.to_s
    command = [ self.namespace, resolved_method ].compact.join(":")

    Blockspring::CLI::Command.register_command(
      :klass       => self,
      :method      => method,
      :command     => command
    )
  end

  def self.alias_command(new, old)
    raise "no such command: #{old}" unless Blockspring::CLI::Command.commands[old]
    Blockspring::CLI::Command.command_aliases[new] = old
  end
end
