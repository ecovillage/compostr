module Compostr
  # Magically syncs custom posts between json, intermediate representation
  # or other forms with data in wordpress. Scary API award.
  class Syncer
    include Compostr::Logging

    attr_accessor :image_uploader
    attr_accessor :synced_uuids
    attr_accessor :updated_uuids
    attr_accessor :force

    def initialize image_uploader, force=false
      @image_uploader = image_uploader
      @synced_uuids   = []
      @updated_uuids  = []
      @force          = force
    end

    # Updates or creates a Custom Post Types Post.
    #
    # The post will be identified by uuid (or not).
    #
    #   new_post_content (a CustomPostType)
    #     The data that **should** be in wordpress (without knowing
    #     of wordpress post or custom field ids).
    #     Usually descendant of Compostr::CustomPostType.
    #
    #   old_post (a hash)
    #     The data currently available in wordpress (including
    #     wordpress post id, custom field ids).
    #
    # Returns post_id (of WordPress) or nil (if failure).
    def merge_push new_post, old_post
      if old_post && old_post.in_wordpress?
        info "#{new_post.class.name} with UUID #{new_post.uuid} found, updating"
        debug old_post.fields.inspect

        new_post.different_from? old_post

        new_post.post_id = old_post.post_id
        new_post.integrate_field_ids old_post

        # TODO unclear how to deal with images
        #attachment_id = @image_uploader.process json['image_url']
        #new_entity.featured_image_id = attachment_id

        #TODO one (cat) is missing when updating single via bundle json

        content = new_post.to_content_hash
        adjust_content content
        # TODO and image ...

        debug "Upload Post ##{new_post.post_id} with wp-content: #{content}"

        post_id = Compostr::wp.editPost(blog_id: 0,
                                        post_id: new_post.post_id,
                                        content: content)
        if post_id
          info "#{new_post.class} ##{new_post.post_id} updated"
        else
          info "#{new_post.class} ##{new_post.post_id} not updated!"
        end
        return post_id
      else
        # Easy, create new one
        info "#{new_post.class.name} with UUID #{new_post.uuid} not found, creating"
        content = new_post.to_content_hash
        adjust_content content

        # Ouch ....
        #attachment_id = @image_uploader.process json['image_url']
        #custom_post.featured_image_id = attachment_id

        debug "Create Post with wp-content: #{content}"

        new_post_id = Compostr::wp.newPost(blog_id: 0,
                                           content: content)
        if new_post_id
          info "#{new_post.class} with WP ID #{new_post_id} created"
        else
          info "#{new_post.class} not created!"
        end
        new_post.post_id = new_post_id
        return new_post_id
      end
    end

    # Add language term and post author data to WP content hash.
    def adjust_content content
      content[:terms_names]  = { 'language' => [ Compostr::config.language_term || 'Deutsch' ] }
      content[:post_author] = Compostr::config.author_id || 1
      # publish? Date ... ?
    end
  end
end
