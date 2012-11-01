module ACH::Records
  class Addendum < Record
    
    @fields = []

    const_field :record_type, '7'
    field :type_code, String, lambda {|f| f}, '05', /\A\d{2}\Z/
    field :payment_data, String, lambda { |f| left_justify(f, 80)}
    field :sequence_number, Integer, lambda { |f| sprintf('%04d', f)}
    field :entry_detail_sequence_number, Integer, lambda { |f| sprintf('%07d', f)}

  end
end