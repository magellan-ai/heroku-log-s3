# frozen_string_literal: true

require 'English'

require 'logger'
require 'heroku-log-parser'

require_relative 'writer/local'
require_relative 'writer/s3'

class App
  PREFIX = ENV.fetch('FILTER_PREFIX', '')
  PREFIX_LENGTH = PREFIX.length
  LOG_REQUEST_URI = ENV.fetch('LOG_REQUEST_URI', nil)

  def initialize
    @logger = Logger.new($stdout)
    @logger.formatter =
      proc do |_severity, _datetime, _progname, msg|
        "[app #{$PROCESS_ID} #{Thread.current.object_id}] #{msg}\n"
      end
    @logger.info 'initialized'

    writer_class =
      if ENV.fetch('WRITER_LIB', '').include?('local')
        Writer::Local
      else
        Writer::S3
      end
    @writer = writer_class.instance
  end

  def call(env)
    extract_lines(env).each do |line|
      msg = line[:msg]
      next unless msg.start_with?(PREFIX)

      @writer.write "#{line[:ts]} #{msg[PREFIX_LENGTH..]}".strip
    end
  rescue Exception
    @logger.error $ERROR_INFO
    @logger.error $ERROR_POSITION
  ensure
    return [200, { 'Content-Length' => '0' }, []]
  end

  private

  def extract_lines(env)
    return [{ msg: env['REQUEST_URI'], ts: '' }] if LOG_REQUEST_URI

    HerokuLogParser.parse(env['rack.input'].read)
                   .collect do |m|
      {
        msg: m[:message],
        ts:  m[:emitted_at].strftime('%Y-%m-%dT%H:%M:%S.%L%z')
      }
    end
  end
end
