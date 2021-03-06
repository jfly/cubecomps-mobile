json.cache! [@competition, "events"], ccm_cache_options(competition_id: @competition.id) do
  json.array! @competition.events do |event|
    json.extract! event, :name
    json.rounds event.rounds do |round|
      json.extract! round, :competition_id, :event_id, :id, :name
      json.live round.live?
      json.finished round.finished?
    end
  end
end
