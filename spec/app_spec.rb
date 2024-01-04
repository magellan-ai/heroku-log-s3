# frozen_string_literal: true

RSpec.describe App do
  let(:app) { described_class.new }
  let(:env) do
    {
      S3_REGION: 'us-east-1',
      S3_KEY: 'my_aws_key',
      S3_SECRET: 'my_aws_secret',
      S3_BUCKET: 'bucket_name',
    }
  end

  before do
    env.each do |k, v|
      allow(ENV).to receive(:fetch).with(k).and_return(v)
    end
  end

  describe 'GET /' do
    it 'works' do
      get '/'
      expect(last_response.status).to eq(200)
    end
  end
end
