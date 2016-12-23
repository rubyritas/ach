require 'holidays'

module ACH
  class NextFederalReserveEffectiveDate
    def initialize(submission_date)
      @submission_date = submission_date
    end

    def result
      @result = @submission_date
      advance_to_next_business_day
      advance_extra_day_if_submission_date_is_holiday_or_weekend
      @result
    end

    private

    def advance_extra_day_if_submission_date_is_holiday_or_weekend
      if holiday_or_weekend?(@submission_date)
        advance_to_next_business_day
      end
    end

    def advance_to_next_business_day
      @result = @result.next_day

      while holiday_or_weekend?(@result)
        @result = @result.next_day
      end
    end

    def holiday?(date)
      Holidays.on(date, :federal_reserve, :observed).any?
    end

    def holiday_or_weekend?(date)
      date.saturday? || date.sunday? || holiday?(date)
    end
  end
end
