require 'aws'
require 'logger'
require_relative './base.rb'

class Writer < WriterBase

  S3_BUCKET_OBJECTS = AWS::S3.new(
    access_key_id: ENV.fetch('S3_KEY'),
    secret_access_key: ENV.fetch('S3_SECRET'),
  ).buckets[ENV.fetch('S3_BUCKET')].objects

  def stream_to(filepath)
    @logger.info "begin #{filepath}"

    temp = Tempfile.new.tap do |t|
      t.binmode
      t.write(_gzip(@io))
      t.close
    end


    S3_BUCKET_OBJECTS[filepath].write(
      temp,
      estimated_content_length: 1 # low-ball estimate; so we can close buffer by returning nil
    )
    @logger.info "end #{filepath}"
  end

  def _gzip(data)
    sio = StringIO.new
    gz = Zlib::GzipWriter.new(sio)
    gz.write(data)
    gz.close
    sio.string
  end

end
