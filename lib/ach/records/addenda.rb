module ACH::Records
  class Addenda < Record
    @fields = []
    
    const_field :record_type, '7'
    field :addenda_type_code, String, lambda {|f| f}, nil, /\A\d{2}\Z/
    field :payment_related_information, String, lambda { |f| left_justify(f, 80)}
    field :sequence_number, Integer, lambda { |f| sprintf('%04d', f)}
    field :entry_detail_sequence_number, Integer, lambda { |f| sprintf('%07d', f)}
    
  end
end