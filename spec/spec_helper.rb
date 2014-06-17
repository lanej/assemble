ENV['MOCK_ASSEMBLE'] ||= 'true'
ENV['RALLY_URL'] ||= "https://rally1.rallydev.com/slm/webservice/"

Bundler.require(:test, :default)

require File.expand_path("../../lib/assemble", __FILE__)

Dir[File.expand_path("../{shared,support}/*.rb", __FILE__)].each { |f| require(f) }

Cistern.formatter = Cistern::Formatter::AwesomePrint

if ENV['MOCK_ASSEMBLE'] == 'true'
  Assemble::Client.mock!
end

Assemble::Client::Mock.timeout       = 0
Assemble::Client::Mock.poll_interval = 0
Assemble::Client::Real.timeout       = 10

RSpec.configure do |config|
  config.filter_run_excluding(mock_only: true) unless ENV['MOCK_ASSEMBLE'] == "true"
  config.order = :random

  config.before(:each) do
    Assemble::Client.reset! if Assemble::Client.mocking?
  end
end
