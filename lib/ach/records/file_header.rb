module ACH::Records
  class FileHeader < Record
    @fields = []

    const_field :record_type, '1'
    const_field :priority_code, '01'
    field :immediate_destination, String, lambda { |f| f.rjust(10) }, nil, /\A(\d{9,10}|)\z/
    field :immediate_origin, String, lambda { |f| f.rjust(10) }, nil, /\A[A-Z\d\s]{1}?\d{9}\s?\z/
    field :transmission_datetime, Time,
        lambda { |f| f.strftime('%y%m%d%H%M')},
        lambda { Time.now }
    field :file_id_modifier, String, nil, 'A', /\A\w\z/
    const_field :record_size, '094'
    const_field :blocking_factor, '10'
    const_field :format_code, '1'
    field :immediate_destination_name, String, lambda { |f| left_justify(f, 23)}
    field :immediate_origin_name, String, lambda { |f| left_justify(f, 23)}
    field :reference_code, String, lambda { |f| left_justify(f, 8)}, ''
  end
end

