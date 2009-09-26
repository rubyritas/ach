module ACH::Records
  class BatchControl < Record
    @fields = []
    
    const_field :record_type, '8'
    
    # TODO: This needs to be changed to reflect whether credits, debits or both.
    const_field :service_class_code, '200'
    # Many of the fields are calculated in Batch.to_ach
    field :entry_count, Integer, lambda { |f| sprintf('%06d', f)}
    field :entry_hash, Integer, lambda { |f| sprintf('%010d', f % (10 ** 10))}
    field :debit_total, Integer, lambda { |f| sprintf('%012d', f)}
    field :credit_total, Integer, lambda { |f| sprintf('%012d', f)}
    
    field :company_identification, String,
        lambda {|f| '1' + f}, nil, /\A\d{9}\Z/,
        'Company Tax ID'
        
    field :message_authentication_code, String,
        lambda { |f| left_justify(f, 19)}, ''

    const_field :reserved, (' ' * 6)
    
    field :originating_dfi_identification, String,
        lambda {|f| f}, nil, /\A\d{8}\Z/
        
    field :batch_number, Integer, lambda { |f| sprintf('%07d', f)}, 1
  end
end