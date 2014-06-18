class Assemble::Client
  class Real
    def get_tags(params={})
      request(
        :path => "/tags",
      )
    end
  end # Real

  class Mock
    def get_tags(params={})
      resources = self.data[:tags].values

      response(
        :body => {
          "QueryResult" => {
            "Errors" => [],
            "Warnings" => [],
            "TotalResultCount" => resources.size,
            "StartIndex" => 1,
            "PageSize" => 20,
            "Results" => resources.map do |r|
              Cistern::Hash.slice(r, "_ref").merge("_refObjectUUID" => r["ObjectID"],
                                                   "_refObjectName" => r["Name"],
                                                   "_type" => "Tag",
                                                  )
            end
          }
        }
      )
    end
  end
end
