class Rivet::Client::Tag < Cistern::Model

  identity :id, aliases: ["ObjectID", "_refObjectUUID"]

  attribute :archived, aliases: "Archived", type: :boolean, default: false
  attribute :name, aliases: ["Name", "_objectName"]
  attribute :version, aliases: ["VersionId", "_objectVersion"]
  attribute :created_at, aliases: ["_CreatedDate", "CreationDate"], type: :time

  def save
    response = if new_record?
                 self.connection.create_tag(archived: self.archived, name: self.name)
               else
                 self.connection.update_tag(self.identity, archived: self.archived, name: self.name)
               end
    merge_attributes(response.body["CreateResult"]["Object"])
  end

  def archive!
    self.archived = true
    self.connection.update_tag(self.identity, archived: self.archived)
  end

  alias destroy archive!
end
