require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
require File.expand_path('../../test_helper', __FILE__)

class PortfolioManagementControllerTest < ActionController::TestCase

  def test_truth
    assert true
  end
  
end