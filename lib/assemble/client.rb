class Assemble::Client < Cistern::Service

  model_path "assemble/models"
  request_path "assemble/requests"

  # tags
  model :tag
  collection :tags
  request :create_tag
  request :destroy_tag
  request :get_tag
  request :get_tags
  request :update_tag

  requires :token

  recognizes :url, :adapter, :logger, :connection_options, :version

  class Real
    attr_reader :connection, :url

    def initialize(options={})
      base_url = options[:url] || ENV['RALLY_URL'] || "https://rally1.rallydev.com/slm/webservice/"
      version  = options[:version] || "v3.0"

      @url   = URI.parse(File.join(base_url, version))
      logger = options[:logger] || Logger.new(nil)
      @token = options[:token]

      adapter            = options[:adapter] || Faraday.default_adapter
      connection_options = options[:connection_options] || {}

      @connection = Faraday.new({url: @url}.merge(connection_options)) do |builder|
        # response
        builder.response :json

        # request
        builder.request :retry,
          :max                 => 5,
          :interval            => 1,
          :interval_randomness => 0.05,
          :backoff_factor      => 2
        builder.request :multipart
        builder.request :json

        builder.use Assemble::Logger, logger

        builder.adapter(*adapter)
      end
    end

    def request(options={})
      method  = (options[:method] || "get").to_s.downcase.to_sym
      url     = Addressable::URI.parse(options[:url] || File.join(@url.to_s, options[:path] || "/"))
      url.query_values = (url.query_values || {}).merge(options[:query] || {})
      params  = options[:params] || {}
      body    = options[:body]
      headers = options[:headers] || {}

      if body.nil? && !params.empty?
        headers["Content-Type"] ||=  "application/x-www-form-urlencoded"
      end
      headers.merge!("ZSESSIONID" => @token) if @token

      # Authentication
      params.merge!(key: @token)

      response = self.connection.send(method) do |req|
        req.url(url.to_s)
        req.headers.merge!(headers)
        req.params.merge!(params)
        req.body = body
      end

      Assemble::Response.new(
        :status  => response.status,
        :headers => response.headers,
        :body    => response.body,
        :request => {
          :method => method,
          :url    => url,
        }
      ).raise!
    end
  end # Real

  class Mock

    def self.data
      @data ||= begin
                  {
                    :tags => {},
                  }
                end
    end

    def response(options={})
      url     = options[:url] || File.join(@url.to_s, options[:path] || "/")
      method  = (options[:method] || :get).to_s.to_sym
      status  = options[:status] || 200
      body    = options[:body]
      headers = {
        "Content-Type" => "application/json; charset=utf-8"
      }.merge(options[:headers] || {})

      Assemble::Response.new(
        :status  => status,
        :headers => headers,
        :body    => body,
        :request => {
          :method => method,
          :url    => url,
        }
      ).raise!
    end

    def url_for(path)
      File.join(@url, path)
    end
  end # Mock
end # Assemble::Client
