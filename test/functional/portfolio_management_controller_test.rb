require File.expand_path('../../test_helper', __FILE__)

class PortfolioManagementControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_sql
    RedminePortfolioManagement::Redmine::project_responsible(1)
    assert true
  end
  
  
end
