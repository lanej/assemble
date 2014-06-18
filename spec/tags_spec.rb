require 'spec_helper'

describe 'tags' do
  let!(:client) { create_client }
  let!(:tag) { client.tags.create(name: "assemble") }

  after(:each) { tag.destroy}

  it "should get tags" do
    expect(client.tags.all.map(&:id)).to include(tag.identity)
  end

  it "should get a tag" do
    fetched = client.tags.get(tag.identity)

    expect(tag.name).to eq("assemble")
    expect(fetched).to eq(tag)
    expect(fetched.name).to eq("assemble")
  end

  it "should not create a duplicate tag" do # just returns the existing one
    expect { client.tags.create(name: "assemble") }.not_to change { client.tags.all.total }
  end
end
