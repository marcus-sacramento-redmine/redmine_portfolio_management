require File.expand_path('../../test_helper', __FILE__)

class PortfolioManagementControllerTest < ActionController::TestCase

  def test_truth
    assert true
  end
  
  def test_database_functions
	RedminePortfolioManagement::Redmine::list_portfolio_values
	assert true
  end
  
end
