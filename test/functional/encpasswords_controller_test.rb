require 'test_helper'

class EncpasswordsControllerTest < ActionController::TestCase
  setup do
    @encpassword = encpasswords(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:encpasswords)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create encpassword" do
    assert_difference('Encpassword.count') do
      post :create, encpassword: { encrypted_password: @encpassword.encrypted_password }
    end

    assert_redirected_to encpassword_path(assigns(:encpassword))
  end

  test "should show encpassword" do
    get :show, id: @encpassword
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @encpassword
    assert_response :success
  end

  test "should update encpassword" do
    put :update, id: @encpassword, encpassword: { encrypted_password: @encpassword.encrypted_password }
    assert_redirected_to encpassword_path(assigns(:encpassword))
  end

  test "should destroy encpassword" do
    assert_difference('Encpassword.count', -1) do
      delete :destroy, id: @encpassword
    end

    assert_redirected_to encpasswords_path
  end
end
