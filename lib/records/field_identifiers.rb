module ACH
  module FieldIdentifiers
    def field(name, klass, stringify = nil, default = nil, validate = nil, msg ='')
      fields << name
      
      # getter
      define_method name do
        instance_variable_get( "@#{name}" )
      end
      
      # setter (includes validations)
      define_method "#{name}=" do | val |
        if validate.kind_of?(Regexp)
          unless val =~ validate
            raise RuntimeError, "#{val} does not match Regexp #{validate}"
          end
        end
        instance_variable_set( "@#{name}", val )
      end
      
      # to_ach
      define_method  "#{name}_to_ach" do
        val = instance_variable_get( "@#{name}" )
        
        if val.nil?
          if default.kind_of?(Proc)
            val = default.call
          elsif default
            val = default
          else
            raise RuntimeError, "val is nil"
          end
        end
        
        if stringify.nil?
          return val
        else
          stringify.call(val)
        end
      end
    end
    
    def const_field(name, val)
      fields << name
      
      # to_ach
      define_method  "#{name}_to_ach" do
        val
      end
    end
    
    def left_justify(val, length)
      val_length = val.length
      if val_length > length
        val = val[0..(length - 1)]
      else
        val = val + (' ' * (length - val_length))
      end
    end
    
    # A routing number, usually, a string consisting of exactly nine digits.
    # Represented by 'bTTTTAAAAC'.
    def routing_field(sym)
      field sym, String, lambda {|f| ' ' + f}, nil, /\A\d{9}\Z/,
        'A string consisting of exactly nine digits'
    end

    # A routing number without leading space
    def spaceless_routing_field(sym)
      field sym, String, lambda {|f| f}, nil, /\A\d{9}\Z/,
        'A string consisting of exactly nine digits'
    end
  end
end