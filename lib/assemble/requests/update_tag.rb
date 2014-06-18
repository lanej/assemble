class Assemble::Client
  class Real
    def update_tag(id, attributes)
      request(
        :body   => {"Tag" => attributes},
        :path   => "/tag/#{id}",
        :method => :post,
      )
    end
  end # Real

  class Mock
    def update_tag(id, _attributes)
      attributes = Cistern::Hash.stringify_keys(_attributes)
      tag        = find(:tags, id)

      subscription = find(:subscriptions, tag["subscription"])
      workspace    = find(:workspaces, tag["workspace"])

      tag.merge!(Cistern::Hash.slice(attributes, "Name", "Archived"))

      response(
        :body => {
          "OperationResult" => {
            "Errors" => [],
            "Warnings" => [],
            "Object" => {
              "_ref" => "https://rally1.rallydev.com/slm/webservice/v3.0/tag/#{tag["ObjectID"]}",
              "_refObjectUUID" => id,
              "_objectVersion" => "8",
              "_refObjectName" => tag["Name"],
              "_CreatedAt" => "37 minutes ago",
              "ObjectID" => id,
              "VersionId" => "8",
              "Subscription" => {
                "_ref" => "https://rally1.rallydev.com/slm/webservice/v3.0/subscription/#{subscription["ObjectID"]}",
                "_refObjectUUID" => subscription["ObjectID"],
                "_refObjectName" => subscription["Name"],
                "_type" => "Subscription"
              },
              "Workspace" => {
                "_ref" => "https://rally1.rallydev.com/slm/webservice/v3.0/workspace/#{workspace["ObjectID"]}",
                "_refObjectUUID" => workspace["ObjectID"],
                "_refObjectName" => workspace["Name"],
                "_type" => "Workspace"
              },
              "_type" => "Tag"
            }.merge(Cistern::Hash.slice(tag, "CreationDate", "Name", "Archived"))
          }
        }
      )
    end
  end # Mock
end
