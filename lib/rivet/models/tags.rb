class Rivet::Client::Tags < Cistern::Collection

  model Rivet::Client::Tag

  def all(options={})
    results = self.connection.get_tags.body["QueryResult"]["Results"]
    self.load(results.map { |r| {"id" => r["_refObjectUUID"], "name" => r["_refObjectName"]} })
  end

  def get(object_id)
    self.new(self.connection.get_tag(object_id).body["Tag"])
  end
end
