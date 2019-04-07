require 'speedtest'
require 'csv'
require 'pry'

require_relative 'mailer'

class Speedchecker
  attr_reader :tester, :speedlog

  DEFAULT_LOG = "#{__dir__}/log/speedlog.csv".freeze

  def initialize(log = nil)
    @tester = Speedtest::Test.new(
      download_runs: 4,
      upload_runs: 4,
      ping_runs: 4,
      download_sizes: [750, 1500],
      upload_sizes: [10000, 400000],
      debug: true
    )
    @speedlog = CSV.open(log || DEFAULT_LOG, 'ab')
  end

  def run
    log_speed_test
    notify_low_speed
  end

  private

  def log_speed_test
    time = Time.now.strftime('%H:%M')
    speedlog << [Date.today.to_s, time, download_rate, upload_rate, latency]
  end

  def notify_low_speed
    return unless download_rate.to_f < CONFIG['settings']['min_download_rate']
    Mailer.new(download_rate, upload_rate, latency).send_mail
  end

  def result
    @result ||= tester.run
  end

  def download_rate
    result.pretty_download_rate
  end

  def upload_rate
    result.pretty_upload_rate
  end

  def latency
    result.latency
  end
end
