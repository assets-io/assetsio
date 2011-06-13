require 'spec_helper'

describe 'AssetsIO helpers' do

  describe '.account[=]' do
    it 'should default to nil' do
      AssetsIO.account.should be_nil
    end

    it 'should set the account' do
      AssetsIO.account = 'my-acct'
      AssetsIO.account.should == 'my-acct'
    end
  end

  describe '.origin[=]' do
    it 'should default to nil' do
      AssetsIO.origin.should be_nil
    end

    it 'should set the account' do
      AssetsIO.origin = 'http://localhost:8080'
      AssetsIO.origin.should == 'http://localhost:8080'
    end
  end

  describe '.asset_url(request, type, *sources)' do
    let(:request) { stub('request', :url => 'http://example.org') }
    let(:type) { 'js' }
    let(:sources) { ['/assets/my.js'] }

    subject { AssetsIO.asset_url(request, type, *sources) }
    let(:asset_spec) {
      subject =~ %r{//.+?/(.+?)\.#{type}}
      JSON.parse(Base64.urlsafe_decode64($1))
    }
    let(:origin_server) {
      subject =~ %r{(.*?//.+?)/.+?\.#{type}}
      $1
    }

    it 'should interpret the source relative to the request#url' do
      asset_spec['s'].should == [ 'http://example.org/assets/my.js' ]
    end

    context 'with muliple sources' do
      let(:sources) { %w(one.js two.js) }

      it 'should interpret all sources relative to the request#url' do
        asset_spec['s'].should == [ 'http://example.org/one.js', 'http://example.org/two.js' ]
      end
    end

    context 'when AssetsIO.orgin has been set' do
      before( :each ) do
        AssetsIO.origin = 'http://localhost:9090'
      end

      it 'should use the given origin server' do
        origin_server.should == 'http://localhost:9090'
      end
    end

    context 'when AssetsIO.orgin has not been set' do
      before( :each ) do
        AssetsIO.origin = nil
      end

      it 'should use AssetsIO.account as the Cloudfront host' do
        AssetsIO.origin = nil
        AssetsIO.account = 'another-account'
        origin_server.should == '//another-account.cloudfront.net'
      end
    end
  end

end
