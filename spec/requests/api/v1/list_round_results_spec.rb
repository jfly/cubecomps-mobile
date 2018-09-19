require 'spec_helper'

describe "List round results" do
  before do
    FakeWeb.register_uri :get, "http://cubecomps.com/live.php?cid=3545&cat=1&rnd=1&dnrd=1", [
      { response: File.read(Rails.root.join "spec", "fixtures", "cubecomps", "2018-09-19", "canarias-open", "rubiks-cube", "first-round.html") },
      { body: "Too Many Requests", status: [429, "Too Many Requests"] }
    ]
  end

  let(:json) { JSON.parse(response.body) }

  it "should list round results" do
    get api_v1_competition_event_round_path(3545, 1, 1)

    expect(json["results"]).to include hash_including("position"=>"1", "top_position"=>true, "name"=>"Sergi Sabat", "country"=>"Spain")
  end
end
