class Rivet::Client
  class Real
    def update_tag(id, attributes)
      request(
        :body   => {"Tag" => attributes},
        :path   => "/tag/#{id}",
        :method => :post,
      )
    end
  end # Real
end
