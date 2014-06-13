module ApplicationHelper

    def bootstrap_paperclip_picture(form, paperclip_object)
        if form.object.send("#{paperclip_object}?")
            content_tag(:div, class: 'control-group') do
                content_tag(:label, "Current Picture", class: 'control-label') +
                content_tag(:div, class: 'controls') do
                    image_tag form.object.send(paperclip_object).send(:url, :small)
                end
            end
        end
    end

    def status_document_link(status)
        if status.document && status.document.attachment?
            link_to(image_tag(status.document.attachment.url(:large)), status.document.attachment.url)
        end
    end
    
    def image_link_to_status(status)
        if status.document && status.document.attachment?
            link_to(image_tag(status.document.attachment.url(:medium)), status)
        end
    end

    def can_display_status?(status)
        signed_in? && current_user.are_we_friends?(status.user) || status.user == current_user || !signed_in?
    end
    
    
    def avatar_profile_link(user, image_options={}, html_options={})
        avatar_url = user.avatar? ? user.avatar.url(:thumb) : user.gravatar_url
        link_to(image_tag(avatar_url, image_options), profile_path(user.profile_name), html_options)
    end

    def page_header(&block)
            content_tag(:div, capture(&block), class: 'page-header')
    end

    def flash_class(type)
        case type
        when "alert"
             "alert-danger"
        when "notice"
             "alert-success"
        when "success"
             "alert-success"
        when "error"
             "alert-warning"
        else
             "alert-info"
        end
    end

    def resource_name
        :user
    end

    def resource
        @resource ||= User.new
    end

    def devise_mapping
        @devise_mapping ||= Devise.mappings[:user]
    end
    
    def can_edit_album?(album)
      signed_in? && current_user == album.user
    end
  
    def album_thumbnail(album)
        if album.pictures.count > 0
          image_tag(album.pictures.first.asset.url(:small))
        else
          "No Pictures"
        end
    end
end
