module ACH
  module StringFormattingHelper
    # Passing in SD to the date signifies same-day to banks. This is used for
    # the company_descriptive_date
    def self.stringify_with_same_day(f)
      return f.upcase if f.to_s.upcase.match(/^SD\d+$/)

      if f.respond_to?(:strftime)
        f = f.strftime('%y%m%d')
      end

      f[0..5].rjust(6)
    end
  end
end
