module ACH::Records
  class BatchHeader < Record
    @fields = []

    const_field :record_type, '5'

    # TODO: This needs to be changed to reflect whether credits, debits or both.
    field :service_class_code, String,
        lambda { |f| f.to_s }, '200',
        lambda { |f| ACH::SERVICE_CLASS_CODES.include?(f.to_i) }
    field :company_name, String, lambda { |f| left_justify(f, 16)}
    field :company_discretionary_data, String,
        lambda { |f| left_justify(f, 20)}, ''
    field :company_identification_code_designator, String, lambda {|f| f}, '1',
        /\A(1|3){1}\Z/
    field :company_identification, String,
        lambda {|f| f}, nil, /\A\d{9}\Z/,
        'Company Tax ID'
    # TODO This should be used to determine whether other records are valid for
    # for this code. Should there be a Class for each code?
    # The default of PPD is purely for my benefit (Jared Morgan)
    field :standard_entry_class_code, String,
        lambda { |f| f.upcase }, 'PPD', /\A\w{3}\Z/
    field :company_entry_description, String,
        lambda { |f| left_justify(f, 10)}
    field :company_descriptive_date, Time,
        lambda { |f| f.strftime('%y%m%d')},
        lambda { Time.now }
    field :effective_entry_date, Time,
        lambda { |f| f.strftime('%y%m%d')}
    const_field :settlement_date, '   '
    const_field :originator_status_code, '1'
    field :originating_dfi_identification, String,
        lambda {|f| f}, nil, /\A\d{8}\Z/

    field :batch_number, Integer, lambda { |f| sprintf('%07d', f)}, 1
  end
end