require 'test_helper'

class B2bDocumentationControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
