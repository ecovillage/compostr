module Compostr
  class EntityCache
    attr_accessor :cpt_class, :name_id_map, :uuid_id_map
    attr_accessor :full_data

    # cpt_class has to be descendant of Compostr::CustomPostType
    def initialize cpt_class
      @cpt_class   = cpt_class
      @name_id_map = nil
      @uuid_id_map = nil
      if !(@cpt_class < Compostr::CustomPostType)
        raise "Unsupported Entity for EntityCache: #{@cpt_class}"
      end
    end

    # Pretty nasty stuff. Stores all posts of cpt in memory (alas,
    # only once) and looks through them until one with uuid found.
    def in_mem_lookup uuid
      # TODO index (hash) on (uu)id, access index only
      if full_data.length == 10_000
        # warn heavily
      elsif full_data.length > 1000
        # warn softly
      end
      uuid_selector = lambda do |x|
        x["custom_fields"].find do |f|
          f["key"] == "uuid" && f["value"] == uuid
        end
      end
      full_data.find &uuid_selector
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
      @name_id_map ||= full_data.map {|p| [p["post_title"], p["post_id"]]}.to_h
    end

    def uuid_id_map
      @uuid_id_map ||= uuid_pid_map
    end

    # Burn-in cache
    def full_data
      @full_data ||= get_all_posts
    end

    # Select entities for which given selector returns true
    # example: selector = lambda {|e| e.to_s == 'keepme'}
    def select_by selector
      full_data.select &selector
    end

    def by_post_id id
      if @full_data.nil?
        Compostr::wp.getPost blog_id: 0,
                              post_id: id
      else
        raise
      end
    end

    private
    def get_all_posts
      Compostr::wp.getPosts blog_id: 0,
        filter: { post_type: @cpt_class.post_type, number: 100_000 }
    end

    def uuid_pid_map
      full_data.map do |post|
        # TODO lambda
        uuid = post["custom_fields"].find {|f| f["key"] == "uuid"}&.fetch("value", nil)
        [uuid, post["post_id"]]
      end.to_h
    end

  end
end
