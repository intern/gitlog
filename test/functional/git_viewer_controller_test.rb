require 'test_helper'

class GitViewerControllerTest < ActionController::TestCase
  test "should get commits" do
    get :commits
    assert_response :success
  end

  test "should get commit" do
    get :commit
    assert_response :success
  end

  test "should get tree" do
    get :tree
    assert_response :success
  end

  test "should get branchs" do
    get :branchs
    assert_response :success
  end

  test "should get branch" do
    get :branch
    assert_response :success
  end

  test "should get tags" do
    get :tags
    assert_response :success
  end

  test "should get tag" do
    get :tag
    assert_response :success
  end

end
