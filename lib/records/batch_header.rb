require 'time'

module ACH
  class BatchHeader < Record
    @fields = []
    
    const_field :record_type, '5'
    
    # TODO: This needs to be changed to reflect whether credits, debits or both.
    const_field :service_class_code, '200'
    field :company_name, String, lambda { |f| left_justify(f, 16)}
    field :company_discretionary_data, String,
        lambda { |f| left_justify(f, 20)}, ''
    field :company_identification, String,
        lambda {|f| '1' + f}, nil, /\A\d{9}\Z/,
        'Company Tax ID'
    const_field :standard_entry_class_code, 'PPD'
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