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

  class Mock
    def create_tag(attributes)
      resource_id, tag = if tag = self.data[:tags].values.find { |t| t["Name"] = attributes["Name"] }
                           [tag["ObjectID"], tag]
                         else
                           uuid = SecureRandom.uuid
                           tag = self.data[:tags][uuid] = attributes.merge(
                             "ObjectID"     => uuid,
                             "_ref"         => url_for("/tag/#{uuid}"),
                             "subscription" => self.subscription["ObjectID"],
                             "workspace"    => self.workspace["ObjectID"],
                           )
                           [uuid, tag]
                         end

      response(
        :body => {
          "CreateResult" => {
            "Errors" => [],
            "Warnings" => [],
            "Object" => {
              "_ref" => "https://rally1.rallydev.com/slm/webservice/v3.0/tag/#{resource_id}",
              "_refObjectUUID" => resource_id,
              "_objectVersion" => "8",
              "_refObjectName" => tag["Name"],
              "_CreatedAt" => "37 minutes ago",
              "ObjectID" => resource_id,
              "VersionId" => "8",
              "Subscription" => {
                "_ref" => url_for("subscription/#{subscription["ObjectID"]}"),
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
  end
end
