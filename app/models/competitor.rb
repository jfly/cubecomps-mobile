class Competitor
  attr_accessor :competition_id, :id, :name

  def initialize(args)
    args.each do |k, v|
      send("#{k}=", v)
    end
  end

  def self.find(competition_id, id)
    new(competition_id: competition_id, id: id)
  end

  def self.build_from_competitor_div(competitor_div)
    competitor_onclick = competitor_div.attr("onclick")
    competitor_url     = competitor_onclick.slice(17..-2)
    competitor_params  = CGI.parse competitor_url.split("?").last

    new(
      competition_id: competitor_params["cid"].first,
      id:             competitor_params["compid"].first,
      name:           competitor_div.text
    )
  end

  def results
    @results ||= fetch_results
  end

  def to_param
    id.to_s
  end

  def cache_key
    ["competitors", competition_id, id].join("/")
  end

  private

  def fetch_results
    headers_tables = doc.css("body > table > tr > td:last-child table.TH")
    results_tables = doc.css("body > table > tr > td:last-child table.TD")
    results = headers_tables.zip(results_tables).flat_map do |headers_table, results_table|
      results_table.css("tr").map do |result_tr|
        Result.build_from_headers_table_and_result_tr(headers_table, result_tr)
      end
    end
    Results.new(results)
  end

  def doc
    @doc ||= Nokogiri::HTML open "http://cubecomps.com/live.php?cid=#{competition_id}&compid=#{id}"
  end
end
