# frozen_string_literal: true

RSpec.describe App do
  let(:app) { described_class.new }
  let(:env) do
    {
      'DURATION'   => 1,
      'WRITER_LIB' => 'local'
    }
  end

  before do
    original_env = ENV.to_h
    stub_const('ENV', original_env.merge(env))
  end

  after do
    FileUtils.rm_rf('output')
  end

  describe 'GET /' do
    it 'works' do
      get '/'
      expect(last_response.status).to eq(200)
    end
  end
end
