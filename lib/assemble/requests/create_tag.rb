class Assemble::Client
  class Real
    def create_tag(attributes)
      request(
        :body   => {"Tag" => attributes},
        :path   => "/tag/create",
        :method => :post,
      )
    end
  end # Real
end
