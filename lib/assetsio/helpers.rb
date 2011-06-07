require 'addressable/uri'
require 'base64'

module AssetsIO

  class << self
    attr_accessor :account, :origin

    def asset_url(request, source, type)
      source_url = Addressable::URI.parse(request.url) + source
      asset_spec = {
        :a => account,
        :r => 'b6',
        :h => 'localhost', # TODO: remove once whitelisting refers to sources
        :s => [ source_url.to_s ],
        :v => 0,
        :w => 0
      }

      origin_server = origin || "//#{account}.cloudfront.net"
      "#{origin_server}/#{Base64.urlsafe_encode64(asset_spec.to_json)}.#{type}"
    end
  end

end
