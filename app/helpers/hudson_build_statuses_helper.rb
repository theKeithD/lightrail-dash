# Helper methods associated with HudsonBuildStatuses.
module HudsonBuildStatusesHelper
  # Fetches job data from the remote Hudson API and filters it down according to the +build+ field.
  def api_data(hudson_build_status)
    api_data = JSON.parse(remote_json(hudson_build_status.api_uri))
    api_data = api_data["jobs"].keep_if do |key, value|
      key["name"] =~ /#{hudson_build_status.build}/
    end
    
    api_data
  end
end
