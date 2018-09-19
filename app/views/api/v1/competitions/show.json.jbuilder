json.cache! ['api', 'v1', @competition], ccm_cache_options do
  json.name @competition.name
  json.events @competition.events do |event|
    json.extract! event, :name
    json.rounds event.rounds do |round|
      json.extract! round, :competition_id, :event_id, :id, :name
      json.live round.live?
      json.finished round.finished?
    end
  end
  json.competitors @competition.competitors do |competitor|
    json.extract! competitor, :competition_id, :id, :name
  end
  json.schedule @competition.schedule do |row|
    json.extract! row, :start, :end, :event_code, :alternate_text, :round_name, :extra_info, :am_pm_format
  end
end
