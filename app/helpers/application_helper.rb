module ApplicationHelper

    def status_document_link(status)
        html = ""
        if status.document && status.document.attachment?
            html << content_tag(:span, "Attachment", class: "label label-info")
            html << link_to(status.document.attachment_file_name, status.document.attachment.url)
        end
        return html.html_safe
    end
    
    def can_display_status?(status)
        signed_in? && current_user.are_we_friends?(status.user) || status.user == current_user || !signed_in?
    end
    
    def avatar_profile_link(user, image_options={}, html_options={})
            link_to(image_tag(user.gravatar_url, image_options), profile_path(user.profile_name), html_options)
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
        else
             ""
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

end
