module ACH::Records
  # The number of records must be a multiple of ten (that is, complete 940
  # character blocks). If needed, rows that consist of the digit "9" may be
  # used to pad the the file.
  #
  # "Nines" records thus consist of a single constant field containing the digit
  # "9" 94 times.
  #
  # See 2008 ACH Rules, Appx 1, Sec 1.5; Appx 2, Sec 2.3
  class Nines < Record
    @fields = []
    
    const_field :record_type, ('9' * 94)
  end
end
