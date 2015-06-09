module ACH::Records
  class BatchHeader < Record
    @fields = []

    const_field :record_type, '5'

    # TODO: this is calculated in Batch.to_ach, so the default should be removed
    field :service_class_code, String,
        lambda { |f| f.to_s }, '200',
        lambda { |f| ACH::SERVICE_CLASS_CODES.include?(f.to_i) }
    field :company_name, String, lambda { |f| left_justify(f, 16)}
    field :company_discretionary_data, String,
        lambda { |f| left_justify(f, 20)}, ''
    field :company_identification, String,
      lambda { |f| f.length == 9 ? "#{f} " : f }, nil, /\A.{9,10}\z/
    # TODO This should be used to determine whether other records are valid for
    # this code. Should there be a Class for each code?
    # The default of PPD is purely for my benefit (Jared Morgan)
    field :standard_entry_class_code, String,
        lambda { |f| f.upcase }, 'PPD', /\A\w{3}\z/
    field :company_entry_description, String,
        lambda { |f| left_justify(f, 10)}
    field :company_descriptive_date, Time,
        lambda { |f| f.strftime('%y%m%d')},
        lambda { Time.now }
    field :effective_entry_date, Time,
        lambda { |f| f.strftime('%y%m%d')}
    field :settlement_date, String,
        lambda { |f| f.to_s }, '   ', /\A([0-9]{3}| {3})\z/
    const_field :originator_status_code, '1'
    field :originating_dfi_identification, String,
        nil, nil, /\A\d{8}\z/

    field :batch_number, Integer, lambda { |f| sprintf('%07d', f)}, 1
  end
end
