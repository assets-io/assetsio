require 'addressable/uri'
require 'base64'

module AssetsIO

  class << self
    attr_accessor :account, :origin

    def asset_url(request, type, *sources)
      request_uri = Addressable::URI.parse(request.url)
      asset_spec = {
        :a => account,
        :r => 'b6',
        :h => 'localhost', # TODO: remove once whitelisting refers to sources
        :s => sources.map { | source| (request_uri + source).to_s },
        :v => 0,
        :w => 0
      }

      origin_server = origin || "//#{account}.cloudfront.net"
      "#{origin_server}/#{Base64.urlsafe_encode64(asset_spec.to_json)}.#{type}"
    end
  end

end
