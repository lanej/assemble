class Assemble::Client
  class Real
    def get_tag(id)
      request(
        :path => "/tags/#{id}",
      )
    end
  end # Real

  class Mock
    def get_tag(id)
      tag = self.find(:tags, id)

      subscription = find(:subscriptions, tag["subscription"])
      workspace    = find(:workspaces, tag["workspace"])

      response(
        :body => {
          "Tag" => {
            "_refObjectUUID" => id,
            "_objectVersion" => "8",
            "_refObjectName" => tag["Name"],
            "_CreatedAt" => "37 minutes ago",
            "ObjectID" => id,
            "VersionId" => "8",
            "Subscription" => {
              "_ref"           => subscription["_ref"],
              "_refObjectUUID" => subscription["ObjectID"],
              "_refObjectName" => subscription["Name"],
              "_type"          => "Subscription"
            },
            "Workspace" => {
              "_ref"           => workspace["_ref"],
              "_refObjectUUID" => workspace["ObjectID"],
              "_refObjectName" => workspace["Name"],
              "_type"          => "Workspace"
            },
            "_type" => "Tag"
          }.merge(Cistern::Hash.slice(tag, "_ref", "CreationDate", "Name", "Archived"))
        }
      )
    end
  end # Mock
end
