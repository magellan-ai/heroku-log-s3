# frozen_string_literal: true

require 'fileutils'

require_relative 'base'

module Writer
  class Local < Base
    def stream_to(filepath)
      @logger.info "begin #{filepath}"
      file = "output/#{filepath}"
      FileUtils.mkdir_p File.dirname(file)
      open(file, 'w') do |f|
        while (data = @io.read)
          f.write(data)
        end
      end
      @logger.info "end #{filepath}"
    end
  end
end
