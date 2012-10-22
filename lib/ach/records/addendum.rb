module ACH::Records
  class Addendum < Record
    
    @fields = []

    const_field :record_type, '7'
    const_field :type_code, '05'
    field :payment_data, String, lambda { |f| left_justify(f, 80)}
    field :sequence_number, Integer, lambda { |f| sprintf('%04d', f)}
    field :entry_detail_sequence_number, Integer, lambda { |f| sprintf('%07d', f)}

  end
end