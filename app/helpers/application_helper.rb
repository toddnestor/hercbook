module ApplicationHelper

    def flash_class(type)
        case type
        when "alert"
             "alert-danger"
        when "notice"
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
