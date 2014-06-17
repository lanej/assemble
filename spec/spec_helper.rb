ENV['MOCK_RIVET'] ||= 'true'
ENV['RALLY_URL'] ||= "https://rally1.rallydev.com/slm/webservice/"

Bundler.require(:test, :default)

require File.expand_path("../../lib/rivet", __FILE__)

Dir[File.expand_path("../{shared,support}/*.rb", __FILE__)].each { |f| require(f) }

Cistern.formatter = Cistern::Formatter::AwesomePrint

if ENV['MOCK_RIVET'] == 'true'
  Rivet::Client.mock!
end

Rivet::Client::Mock.timeout       = 0
Rivet::Client::Mock.poll_interval = 0
Rivet::Client::Real.timeout       = 10

RSpec.configure do |config|
  config.filter_run_excluding(mock_only: true) unless ENV['MOCK_RIVET'] == "true"
  config.order = :random

  config.before(:each) do
    Rivet::Client.reset! if Rivet::Client.mocking?
  end
end
