# frozen_string_literal: true

require 'aws-sdk-s3'
require 'logger'
require 'tempfile'

require_relative 'base'

module Writer
  class S3 < Base
    def initialize
      @bucket = Aws::S3::Resource.new(region: ENV.fetch('AWS_REGION'))
                                 .bucket(ENV.fetch('S3_BUCKET'))

      super
    end

    def stream_to(filepath)
      @logger.info "begin #{filepath}"
      Tempfile.create(filepath) do |tempfile|
        while (data = @io.read)
          tempfile.write(data)
        end
        tempfile.rewind
        @bucket.object(filepath).upload_file(tempfile)
      end
      @logger.info "end #{filepath}"
    end
  end
end
