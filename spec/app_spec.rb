# frozen_string_literal: true

RSpec.describe App do
  let(:app) { described_class.new }
  let(:env) do
    {
      'AWS_REGION'            => 'us-east-1',
      'AWS_ACCESS_KEY_ID'     => 'my_aws_key',
      'AWS_SECRET_ACCESS_KEY' => 'my_aws_secret',
      'DURATION'              => 1,
      'S3_BUCKET'             => 'bucket_name'
    }
  end

  before do
    original_env = ENV.to_h
    stub_const('ENV', original_env.merge(env))

    allow(Writer::S3).to receive(:instance).and_return(spy(Writer::S3))
  end

  describe 'GET /' do
    it 'works' do
      get '/'
      expect(last_response.status).to eq(200)
    end
  end
end
