module Compostr
  # Describe a Custom Field Value with optionally an id (corresponding to the WordPress data).
  class CustomFieldValue
    attr_accessor :id, :key, :value

    def initialize id, key, value
      @id    = id
      @key   = key
      @value = value
    end

    # Convert to hash that is consumable by RubyPress/Wordpress.
    # Important that neither key nor value are present for custom field
    # values that should be *deleted* in wordpress instance.
    def to_hash
      if @id
        hsh = { id: @id }
        hsh[:key]   = @key if @key
        hsh[:value] = @value if @value
        hsh
      else
        hsh = {}
        hsh[:key]   = @key if @key
        hsh[:value] = @value if @value
        hsh
      end
    end
  end

  # CustomField NullValue Object.
  class NullCustomFieldValue
    def id; nil; end
    def key; nil; end
    def value; nil; end
  end

  # Shortcut to mark fields for deletion.
  class DeleteCustomFieldValue < CustomFieldValue
    def initialize(id)
      super(id, nil, nil)
    end
  end
end
