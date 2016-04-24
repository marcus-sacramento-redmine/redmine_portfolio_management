Redmine::Plugin.register :redmine_portfolio_management do
  name 'Redmine Portfolio Management plugin'
  author 'Marcus Sacramento'
  description 'Plugin para permitir o uso de Portfolio dos projetos'
  version '1.0.1'
  url 'https://github.com/marcus-sacramento-redmine/redmine_portfolio_management'
  author_url 'https://github.com/MarcuSacramento'
  
  menu :top_menu, :portfolio_management, { :controller => 'portfolio_management', :action => 'index' }, :caption => :portfolio_management_menu
  settings :default => {:portfolio_management_attribute => 'Portfolio name'}, :partial => 'settings/redmine_portfolio_management_settings'
  
end
