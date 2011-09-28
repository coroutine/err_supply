module ErrSupply
  module ViewHelpers
    
    # Converts the given object's error hash into our JSON structure and
    # triggers a custom event on the associated form element.
    #
    def err_supply(obj, options={})
      id = obj.new_record? ? dom_id(obj) : dom_id(obj, :edit)
      h  = err_supply_hash(obj, options.merge({ :prefix => obj.class.name.underscore }))

      "$('##{id}').trigger('err_supply:loaded', #{h.to_json});".html_safe
    end



    protected
    
    # This method can be called recursively to unpack a rails object's error hash 
    # into something more manageable for the view. Basically, it uses the keys in the
    # object's error hash to traverse the object graph and expand the errors into a
    # flattened hash, keyed using the dom ids rails will generate for the 
    # associated objects.
    #
    # Because the method is called recursively, it only pays attention to errors for 
    # the given object and its immediate child collections.  More remote descendents
    # will be processed in subsequent passes.
    #
    def err_supply_hash(obj, options={})

      #---------------------------------------------
      # set up main variables
      #---------------------------------------------

      prefix  = options[:prefix]
      errors  = obj.errors
      h       = {}


      #---------------------------------------------
      # apply options to local attrs
      #---------------------------------------------

      # get keys
      attrs   = errors.keys.select { |k| k.to_s.split(".").size == 1 }

      # whitelist/blacklist keys
      if options.has_key?(:only)
        attrs = attrs.select { |k| Array(options[:only]).flatten.include?(k) }
      end
      if options.has_key?(:except)
        attrs = attrs.reject { |k| Array(options[:except]).flatten.include?(k) }
      end

      # apply errors that match our list (slightly inefficient, but a touch easier to read)
      attrs.each do |attr|
        o  = options[attr.to_sym] || {}
        id = "#{prefix}_#{(o[:key] || attr).to_s}"

        unless h.has_key?(id)
          h[id] = {
            "label"    => obj.class.human_attribute_name(attr),
            "messages" => []
          }
        end

        h[id]["label"]    = o[:label].to_s.underscore.humanize unless o[:label].nil?
        h[id]["messages"] = (h[id]["messages"] + errors[attr].map { |msg| "#{msg}.".gsub("..", ".") }).flatten
      end


      #---------------------------------------------
      # apply options to children
      #---------------------------------------------
      
      # get keys
      assoc_names = errors.keys.map { |k| k.to_s.split(".") }.select { |a| a.many? }.map { |a| a[0] }.compact.uniq

      # if child has errors or is invalid (i.e., we prefer explicitly declared errrors),
      # call function recursively and merge results
      assoc_names.each do |assoc_name|
        c_options = options[assoc_name.to_sym] || {}
        obj.send("#{assoc_name}").each_with_index do |child, index|
          if !child.errors.empty? or child.invalid?
            c_prefix = "#{prefix}_#{assoc_name}_attributes_#{index}"
            c_hash   = err_supply_hash(child, c_options.merge({ :prefix => c_prefix }))

            h.merge!(c_hash)
          end
        end
      end


      #---------------------------------------------
      # return the hash
      #---------------------------------------------
      h    

    end
    
  end
end