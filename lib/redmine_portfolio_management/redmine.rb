module RedminePortfolioManagement

    module Redmine
        extend self

        def plugin
            ::Redmine::Plugin.find(:redmine_portfolio_management)
        end

        def settings
            if ActiveRecord::Base.connection.table_exists?(:settings) && self.plugin && Setting.plugin_redmine_portfolio_management
                Setting.plugin_redmine_portfolio_management
            else
                plugin.settings[:default]
            end
        end

        def portfolio_management_attribute
            custom_field(:portfolio_management_attribute)
        end
        
        def portfolio_management_manager_attribute
            custom_field(:portfolio_management_manager_attribute)
        end
		
		def portfolio_management_visible_attribute
            custom_field(:portfolio_management_visible_attribute)
        end
        
        def list_projects_portfolio
            sql = "SELECT * from #{Project.table_name}"
            projects = ActiveRecord::Base.connection.select_all(sql)
            s= ' t '
            projects.each do |project|
               s<< project['id'] +"-"
            end
            s
        end
        
        
        
        
    
		protected
            def custom_field(name)
                CustomField.find_by_name(settings[name.to_sym])
            end
    end
end
