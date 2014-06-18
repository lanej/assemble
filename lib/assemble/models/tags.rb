class Assemble::Client::Tags < Cistern::Collection

  attribute :errors,    aliases: ["Errors"],           type: :array
  attribute :page_size, aliases: ["PageSize"],         type: :integer
  attribute :start,     aliases: ["StartIndex"],       type: :integer
  attribute :total,     aliases: ["TotalResultCount"], type: :integer
  attribute :warnings,  aliases: ["Warnings"],         type: :array

  model Assemble::Client::Tag

  def all(options={})
    result = self.connection.get_tags.body["QueryResult"]
    records = result["Results"]

    merge_attributes(result)
    self.load(records)
  end

  def get(object_id)
    self.new(self.connection.get_tag(object_id).body["Tag"])
  end
end
