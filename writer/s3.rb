# frozen_string_literal: true

require 'aws-sdk-s3'
require 'logger'
require_relative 'base'

class Writer < WriterBase
  REGION = ENV.fetch('S3_REGION')
  BUCKET = ENV.fetch('S3_BUCKET')

  def initialize
    super
    @s3_client = Aws::S3::Client.new(access_key_id:     ENV.fetch('S3_KEY'),
                                     secret_access_key: ENV.fetch('S3_SECRET'))
  end

  def stream_to(filepath)
    @logger.info "begin #{filepath}"
    @s3_client.put_object(region: REGION,
                          bucket: BUCKET,
                          key:    filepath,
                          body:   @io)
    @logger.info "end #{filepath}"
  end
end
