require 'test_helper'

class IphotosControllerTest < ActionController::TestCase
  setup do
    @iphoto = iphotos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:iphotos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create iphoto" do
    assert_difference('Iphoto.count') do
      post :create, iphoto: { i_id: @iphoto.i_id, status: @iphoto.status, tag_id: @iphoto.tag_id, url: @iphoto.url, username: @iphoto.username }
    end

    assert_redirected_to iphoto_path(assigns(:iphoto))
  end

  test "should show iphoto" do
    get :show, id: @iphoto
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @iphoto
    assert_response :success
  end

  test "should update iphoto" do
    put :update, id: @iphoto, iphoto: { i_id: @iphoto.i_id, status: @iphoto.status, tag_id: @iphoto.tag_id, url: @iphoto.url, username: @iphoto.username }
    assert_redirected_to iphoto_path(assigns(:iphoto))
  end

  test "should destroy iphoto" do
    assert_difference('Iphoto.count', -1) do
      delete :destroy, id: @iphoto
    end

    assert_redirected_to iphotos_path
  end
end
