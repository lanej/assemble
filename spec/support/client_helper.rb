module ClientHelper
  def create_client(options={})
    client_options = {}
    client_options.merge!(token: options[:token] || File.read(File.expand_path("../../../.assemble", __FILE__)).strip)
    client_options.merge!(logger: Logger.new(STDOUT)) if ENV["VERBOSE"]

    Assemble::Client.new(client_options)
  end
end

RSpec.configure { |config| config.include(ClientHelper) }
