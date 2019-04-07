require 'i18n'
require 'yaml'
require_relative 'speedchecker'

I18n.load_path << Dir[File.expand_path("#{__dir__}/config/locales") + "/*.yml"]
I18n.default_locale = :en # (note that `en` is already the default!)

CONFIG = YAML.load(
  File.read(File.join(__dir__, 'config/settings.yml'))
)

Speedchecker.new.run
