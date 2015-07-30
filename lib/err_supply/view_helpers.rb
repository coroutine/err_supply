module ErrSupply
  module ViewHelpers

    # Converts the given object's error hash into our JSON structure and
    # triggers a custom event on the associated form element.
    #
    def err_supply(obj, options={})
      id      = obj.new_record? ? dom_id(obj) : dom_id(obj, :edit)
      prefix  = obj.class.name.underscore.split('/').last
      payload = err_supply_hash(obj, options.merge({ :prefix => prefix }))

      "$('##{ id }').trigger('err_supply:loaded', #{ payload.to_json });".html_safe
    end

  end
end
