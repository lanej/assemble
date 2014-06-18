class Assemble::Client::Tag < Cistern::Model

  identity :id, aliases: ["ObjectID", "_refObjectUUID"]

  attribute :archived,   aliases: "Archived",                               type: :boolean, default: false
  attribute :name,       aliases: ["Name", "_objectName", "_refObjectName"]
  attribute :version,    aliases: ["VersionId", "_objectVersion"]
  attribute :created_at, aliases: ["_CreatedDate", "CreationDate"],         type: :time

  def save
    attributes = {
      "Archived" => self.archived,
      "Name"     => self.name,
    }

    data = if new_record?
             self.connection.create_tag(attributes).body["CreateResult"]["Object"]
           else
             self.connection.update_tag(self.identity, attributes).body["OperationResult"]["ObjectID"]
           end

    merge_attributes(data)
  end

  def archive!
    self.archived = true
    self.connection.update_tag(self.identity, archived: self.archived)
  end

  alias destroy archive!
end
