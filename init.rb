Redmine::Plugin.register :redmine_portfolio_management do
  name 'Redmine Portfolio Management plugin'
  author 'Marcus Sacramento'
  description 'Plugin para permitir a visualização de Portfólio dos projetos da aplicação'
  version '0.0.2'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
  
  menu :top_menu, :portfolio_management, { :controller => 'portfolio_management', :action => 'index' }, :caption => :portfolio_management_menu
  settings :default => {'empty' => true}, :partial => 'settings/redmine_portfolio_management_settings'
  
end
