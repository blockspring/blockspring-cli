require 'netrc'
require 'rest_client'

class Blockspring::CLI::Auth
  class << self
    def host
      ENV['BLOCKSPRING_API_HOST'] || 'localhost:3000'
    end

    # TODO: change to https
    def base_url
      protocol = ENV['BLOCKSPRING_API_PROTOCOL'] || 'http'
      "#{protocol}://#{host}"
    end

    def with_tty(&block)
      return unless $stdin.isatty
      begin
        yield
      rescue
        # fails on windows
      end
    end

    def echo_off
      with_tty do
        system "stty -echo"
      end
    end

    def echo_on
      with_tty do
        system "stty echo"
      end
    end

    def ask
      $stdin.gets.to_s.strip
    end

    def ask_for_password
      begin
        echo_off
        password = ask
        puts
      ensure
        echo_on
      end
      return password
    end

    def ask_for_credentials
      puts "Enter your Blockspring credentials."

      print "Username or email: "
      login = ask

      print "Password (typing will be hidden): "
      password = ask_for_password

      [login, api_key(login, password)]
    end

    def api_key(login, password)
      response = RestClient.post "#{base_url}/api_login", login: login, password: password
      if response.code == 200
        response.to_str
      else
        raise 'login failed'
      end
    end

    def reauthorize
      @credentials = ask_for_and_save_credentials
    end

    def delete_credentials
      if netrc
        netrc.delete(host)
        netrc.save
      end
      @credentials = nil
    end

    def get_credentials
      @credentials ||= (read_credentials || ask_for_and_save_credentials)
    end

    def ask_for_and_save_credentials
      @credentials = ask_for_credentials
      write_credentials
      @credentials
    end

    def write_credentials
      FileUtils.mkdir_p(File.dirname(netrc_path))
      FileUtils.touch(netrc_path)
      netrc[host] = @credentials
      netrc.save
    end

    def netrc_path
      default = Netrc.default_path
      encrypted = default + ".gpg"
      if File.exists?(encrypted)
        encrypted
      else
        default
      end
    end

    def netrc   # :nodoc:
      @netrc ||= begin
        File.exists?(netrc_path) && Netrc.read(netrc_path)
      rescue => error
        if error.message =~ /^Permission bits for/
          perm = File.stat(netrc_path).mode & 0777
          abort("Permissions #{perm} for '#{netrc_path}' are too open. You should run `chmod 0600 #{netrc_path}` so that your credentials are NOT accessible by others.")
        else
          raise error
        end
      end
    end

    def read_credentials
      if ENV['BLOCKSPRING_API_KEY']
        ['', ENV['BLOCKSPRING_API_KEY']]
      else
        if netrc
          netrc[host]
        end
      end
    end
  end
end
