module ACH::Records
  class Nines < Record
    @fields = []
    
    const_field :record_type, ('9' * 94)
  end
end
