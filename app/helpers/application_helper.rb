module ApplicationHelper

    def can_display_status?(status)
        signed_in? && current_user.are_we_friends?(status.user) || status.user == current_user || !signed_in?
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
