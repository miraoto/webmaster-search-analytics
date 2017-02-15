require 'parallel'

class SearchAnalyticsService
  def self.find_rows_by_url(cliente, urls)
    search_keys = {}
    Parallel.each_with_index(urls, in_threads: 4) do |url, index|
      begin
        results = search_analytics_rows(client, url)
      rescue => e
        puts "接続失敗"
        sleep(3)
        puts "retry.."
        retry
      end
      search_keys[url] = []
      search_key_num = 0
      if results.present?
        # https://developers.google.com/webmaster-tools/v3/searchanalytics/query?hl=ja
        search_keys[url] = results.map do |result|
          normalized_search_key(result['keys'][0]) if !reject_search_key?(result['keys'][0])
        end.compact.uniq
      end
      p "残り#{urls.count - index} #{url}"
    end
    search_keys
  end

  def self.search_analytics_rows(client, url)
    result = client.execute(
      api_method: client.discovered_api('webmasters', 'v3').searchanalytics.query,
      parameters: {
        "siteUrl": SITE_URL,
      },
      body_object:{
        "startDate": SEARCH_START_DATE.strftime("%Y-%m-%d"),
        "endDate": SEARCH_END_DATE.strftime("%Y-%m-%d"),
        "dimensions":[
          "query"
        ],
        "dimensionFilterGroups": [
          {
            "filters": [
              {
                "dimension": "page",
                "operator": "contains",
                "expression": url
              }
            ]
          }
        ],
        "rowLimit": MAX_SEARCH_KEY_NUM * 4
      }
    )
    return JSON.parse(result.response.body)["rows"]
  end

  private

  def self.normalized_search_key(search_key)
    search_key
      .tr('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z')
      .gsub(/^[\s　]+|[\s　]+$/, '')
      .gsub(/[\s|　]/, ' ')
      .gsub(/\s+/, ' ')
  end

  def self.reject_search_key?(search_key)
    (search_key =~ /hoge|fuga|piyo/).nil?.!
  end
end
