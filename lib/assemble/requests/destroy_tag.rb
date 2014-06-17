class Assemble::Client
  class Real
    def destroy_tag(id)
      request(
        :body   => {"Tag" => attributes},
        :path   => "/tag/create",
        :method => :post,
      )
    end
  end # Real
end
