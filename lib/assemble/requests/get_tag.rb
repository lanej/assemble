class Assemble::Client
  class Real
    def get_tag(id)
      request(
        :body => nil,
        :path => "/tags/#{id}",
      )
    end
  end # Real
end
