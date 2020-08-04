module ACH
  module FieldIdentifiers

    # these are used to convert non ascii characters to UTF-8

    ENCODING_OPTIONS = {
      :invalid           => :replace,  # Replace invalid byte sequences
      :undef             => :replace,  # Replace anything not defined in ASCII
      :replace           => '',        # Use a blank for those replacements
    }

    # NOTE: the msg parameter is unused and should be removed when the API can change
    def field(name, klass, stringify = nil, default = nil, validate = nil, msg ='')
      fields << name

      # getter
      define_method name do
        instance_variable_get( "@#{name}" )
      end

      # setter (includes validations)
      define_method "#{name}=" do | val |
        if val.nil? && default
          # Leave value as nil, so that default is used.
        elsif validate.kind_of?(Regexp)
          unless val =~ validate
            raise InvalidError, "#{val} does not match Regexp #{validate} for field #{name}"
          end
        elsif validate.respond_to?(:call) # Proc with value as argument
          unless validate.call(val)
            raise InvalidError, "#{val} does not pass validation Proc for field #{name}"
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
            raise RuntimeError, "val of #{name} is nil"
          end
        end

        if val.kind_of?(String)
          if RUBY_VERSION < '1.9'
            val = Iconv.conv('ASCII//IGNORE', 'UTF8', val)
          else
            val = val.encode(Encoding.find('ASCII'), **ENCODING_OPTIONS)
          end
        end

        if stringify
          stringify.call(val)
        else
          val
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

    # Left justify value and truncate to length if needed
    def left_justify(val, length)
      val[0..(length - 1)].ljust(length)
    end

    # A routing number without leading space
    def spaceless_routing_field(sym)
      field sym, String, nil, nil, /\A\d{9}\z/
    end
  end
end
