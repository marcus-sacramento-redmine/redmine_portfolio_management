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
       
        # Define o Atributo de Campo customizado para o Portfolio
        def portfolio_management_attribute
            custom_field(:portfolio_management_attribute)
        end
        
        def portfolio_management_manager_attribute
            custom_field(:portfolio_management_manager_attribute)
        end
		
		def portfolio_management_visible_attribute
            custom_field(:portfolio_management_visible_attribute)
		end
        
        def list_portfolio_values
            sql = "Select distinct cf.id,cv.Value,lower(cv.Value) as value_id from #{CustomValue.table_name} cv,#{CustomField.table_name} cf where cf.id = cv.custom_field_id and cf.type = 'ProjectCustomField' and name = '#{portfolio_management_attribute::name}' and cv.Value <> ''"
            portfolios = ActiveRecord::Base.connection.select_all(sql)
            portfolios
        end
        
        def list_projects_portfolio(portfolio_type, portfolio_name)
            sql = "select cv.value,p.id as project_id,p.name,p.identifier,(case when(select pai.name from #{Project.table_name} pai where pai.id =  p.parent_id)is null then 'N/A' else (select pai.name from projects pai where pai.id =  p.parent_id) END) as parent_project, p.parent_id,DATE_FORMAT(p.created_on,'dd/mm/yyyy') as created_on, DATE_FORMAT(p.updated_on,'dd/mm/yyyy') as updated_on, p.is_public from #{CustomValue.table_name} cv, #{Project.table_name} p where cv.customized_id = p.id and cv.customized_type = 'Project' and custom_field_id = #{portfolio_type} and cv.value = '#{portfolio_name}' and p.status<>9 order by parent_project,p.created_on desc"
            projects = ActiveRecord::Base.connection.select_all(sql)
            projects
        end
        
        def start_date_project(project_id)
            sql = "select (CASE WHEN i.start_date is null then '-' else  DATE_FORMAT(i.start_date,'DD/MM/YYYY') END) as start_date from #{Issue.table_name} i where i.project_id = #{project_id} order by i.start_date limit 1"
			result = "N/A"
			starts_date = ActiveRecord::Base.connection.select_all(sql)
            starts_date.each do |date|
                result = date['start_date']
            end
            result
        end
        
        def due_date_project(project_id)
            sql = "select (CASE WHEN i.due_date is null then '-' else  DATE_FORMAT(i.due_date,'DD/MM/YYYY') END) as due_date from #{Issue.table_name} i where i.project_id = #{project_id} order by i.due_date desc limit 1"
			result = "N/A"
			starts_date = ActiveRecord::Base.connection.select_all(sql)
            starts_date.each do |date|
                result = date['due_date']
            end
            result
        end
        
        def project_responsible(project_id)
          
          sql = "select (case when (select (CASE WHEN u.firstname ='' then u.lastname else u.lastname  ||' '||u.firstname END) from users u where u.id||'' =  cv.value)is null then 'N/A' else (select (CASE WHEN u.firstname ='' then u.lastname else u.lastname  ||' '||u.firstname END) from users u where u.id||'' =  cv.value)end) as assigned_to from projects p left outer join custom_values cv on(cv.customized_id = p.id ) where cv.customized_type = 'Project' and cv.custom_field_id = #{portfolio_management_manager_attribute::id} and p.id = #{project_id}"
		  result = ""
			responsibles = ActiveRecord::Base.connection.select_all(sql)
            responsibles.each do |responsible|
                result = result+responsible['assigned_to']
            end
          result
        end
        
        def project_evolution(project_id)
            sql = "select closed, count(1) as total from( select issue.id, issue.project_id,(CASE WHEN issue.is_closed = true then 'Fechado' else 'Aberto' END)as closed,issue.status, issue.name,  issue.start_date, issue.due_date, issue.done_ratio,(CASE WHEN users.firstname is null AND users.lastname is null then 'Não Atribuído'   WHEN users.firstname ='' then users.lastname else users.firstname ||' '||users.lastname END) as assigned_to  from  (select i.id, i.project_id,it.name as status, it.is_closed,i.assigned_to_id , t.name , i.subject,DATE_FORMAT(i.start_date,'DD/MM/YYYY') as start_date,  DATE_FORMAT(i.due_date,'DD/MM/YYYY') as due_date,i.done_ratio from issues i, trackers t, issue_statuses it where 1=1 and i.project_id =#{project_id} and i.tracker_id  = t.id and  it.id = i.status_id )issue left outer join users on (users.id = issue.assigned_to_id )) issues group by closed"
		    open = 0
		    closed = 0
		    total = 0
		    percentile=0.0
		    openeds_closeds = ActiveRecord::Base.connection.select_all(sql)
            openeds_closeds.each do |open_close|
               if open_close['closed'] == "Aberto" then
                 open = open_close['total']
               end
               if open_close['closed'] == "Fechado" then
                 closed = open_close['total']
               end
            end
		     
              total= Integer(open)+ Integer(closed)
            
             if total > 0 then
               percentile=(Float(closed)/Float(total))*100.0
             end
             
            "#{percentile.round(2)} %"
            
            
        end
        
        def count_page_projects_portfolio(per_page,portfolio_type, portfolio_name)
            sql = "select count(p.identifier) from #{CustomValue.table_name} cv, #{Project.table_name} p where cv.customized_id = p.id and cv.customized_type = 'Project' and p.status<>9 and custom_field_id = #{portfolio_type} and cv.value = '#{portfolio_name}'"
            total = 0
            result = 0
            projects = ActiveRecord::Base.connection.select_all(sql)
             projects.each do |total|
               total = total
             end
            
            if total > 0 then
               result=(Float(_total)/Float(per_page))
            end
            
            total
        end
        
    
		protected
            def custom_field(name)
                CustomField.find_by_name(settings[name.to_sym])
            end
    end
end
