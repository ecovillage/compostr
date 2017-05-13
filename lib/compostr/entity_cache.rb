module Compostr
  class EntityCache
    attr_accessor :cpt, :name_id_map, :uuid_id_map
    attr_accessor :full_data

    # cpt has to be a Compostr::PostType extending class/module
    def initialize cpt
      @cpt         = cpt
      @name_id_map = nil
      @uuid_id_map = nil
      if !cpt.is_a? Compostr::PostType
        raise "Unsupported Entity for EntityCache: #{cpt.class}"
      end
    end

    # Pretty nasty stuff. Stores all posts of cpt in memory (alas,
    # only once) and looks through them until one with uuid found.
    def in_mem_lookup uuid
      # TODO index (hash) on (uu)id, access index only
      @full_data ||= cpt.get_all_posts
      if @full_data.length == 10_000
        # warn heavily
      elsif @full_data.length > 1000
        # warn softly
      end
      uuid_selector = lambda do |x|
        x["custom_fields"].find do |f|
          f["key"] == "uuid" && f["value"] == uuid
        end
      end
      @full_data.find &uuid_selector
      #@full_data.find &WPEvent::Lambdas.with_cf_uuid(uuid)
    end

    def id_of_name name
      return [] if name.nil? || name.empty?
      name_id_map[name]
    end

    def id_of_names names
      return [] if names.nil? || names.empty?
      names.map{|name| name_id_map[name]}
    end

    def id_of_uuid uuid
      return [] if uuid.nil? || uuid.empty?
      uuid_id_map[uuid]
    end

    def id_of_uuids uuids
      return [] if uuids.nil? || uuids.empty?
      uuids.map{|uuid| id_of_uuid uuid}
    end

    # init and return @name_id_map
    def name_id_map
      if @name_id_map.nil?
        @name_id_map = cpt.name_pid_map
      end
      @name_id_map || {}
    end

    def uuid_id_map
      if @uuid_id_map.nil?
        @uuid_id_map = cpt.uuid_pid_map
      end
      @uuid_id_map || {}
    end

    # Burn-in cache
    def full_data
      @full_data ||= cpt.get_all_posts
    end

    # Select entities for which given selector returns true
    # example: selector = lambda {|e| e.to_s == 'keepme'}
    def select_by selector
      full_data.select &selector
    end
  end
end
