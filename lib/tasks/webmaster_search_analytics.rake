require 'lib/search_console/api_client'
require 'lib/file_util'

SEARCH_BASE_DATE = Date.today
SEARCH_START_DATE = SEARCH_BASE_DATE - 120
SEARCH_END_DATE = SEARCH_BASE_DATE - 1
MAX_NUMBER_RESULT_COUNT = 100

namespace :webmaster_search_analytics do
  desc 'Analyze the performance by the google organic search.'
  task :query_by_request_urls, [:request_urls] do |task, args|
    begin
      urls = [args[:request_urls], args.extras].flatten

      secrets = YAML::load(ERB.new(IO.read('secrets.yml')).result)
      SITE_URL = secrets['root_url']

      client = SearchConsole::ApiClient.create(secrets['google_oauth'])
      rows = SearchAnalyticsService.find_rows_by_url(client, urls)

      FileUtil.import_stats(rows)
    end
  end
end
