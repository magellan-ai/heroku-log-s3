require "aws-sdk-s3"
require 'logger'
require_relative './base.rb'

class Writer < WriterBase

  S3_CLIENT = AWS::S3::Client.new({
    access_key_id: ENV.fetch('S3_KEY'),
    secret_access_key: ENV.fetch('S3_SECRET'),
  })

  def stream_to(filepath)
    @logger.info "begin #{filepath}"
    S3_CLIENT.put_object(bucket: ENV.fetch('S3_BUCKET'), key: filepath, body: @io)
    @logger.info "end #{filepath}"
  end

end
