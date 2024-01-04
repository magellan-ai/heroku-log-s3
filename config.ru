# frozen_string_literal: true

if ENV['NEW_RELIC_LICENSE_KEY']
  require 'newrelic_rpm'
  NewRelic::Agent.manual_start
end

require_relative 'app'

$stdout.sync = true

if ENV['HTTP_USER'].to_s == '' && ENV['HTTP_PASSWORD'].to_s == ''
  # skip
else
  use Rack::Auth::Basic, 'Restricted Area' do |username, password|
    [username, password] == [ENV.fetch('HTTP_USER', nil), ENV.fetch('HTTP_PASSWORD', nil)]
  end
end

run App.new
