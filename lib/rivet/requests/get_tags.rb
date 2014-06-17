class Rivet::Client
  class Real
    def get_tags(params={})
      request(
        :path => "/tags",
      )
    end
  end # Real
end
