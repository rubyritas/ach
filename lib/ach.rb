module ACH
  # transaction codes
  CHECKING_CREDIT = '22'
  CHECKING_DEBIT = '27'
  CHECKING_CREDIT_PRENOTE = '23'
  CHECKING_DEBIT_PRENOTE = '28'

  SAVING_CREDIT = '32'
  SAVING_DEBIT = '37'
  SAVING_CREDIT_PRENOTE = '33'
  SAVING_DEBIT_PRENOTE = '38'

  LOAN_CREDIT = '52'
  LOAN_CREDIT_PRENOTE = '53'

  # Valid service class codes
  SERVICE_CLASS_CODES = [
    200, # ACH Entries Mixed Debits and Credits
    220, # ACH Credits Only
    225, # ACH Debits Only
    280  # ACH Automated Accounting Advices
  ]

  DEFAULT_EOL = "\r\n"

  def self.eol
    DEFAULT_EOL
  end
end

require 'time'
require 'iconv' if RUBY_VERSION < '1.9'
require 'ach/errors'
require 'ach/field_identifiers'
require 'ach/ach_file'
require 'ach/batch'
require 'ach/next_federal_reserve_effective_date'
require 'ach/version'
require 'ach/string_formatting_helper'

# Require records files
require 'ach/records/record'

Dir.new(File.dirname(__FILE__) + '/ach/records').each do |file|
  require('ach/records/' + File.basename(file)) if File.extname(file) == ".rb"
end

# Include Records module to simplify accessing Records classes.
module ACH
  include Records
end
