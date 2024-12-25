require "test_helper"

class ArtisansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @artisan = artisans(:one)
  end

  test "should get index" do
    get artisans_url
    assert_response :success
  end

  test "should get new" do
    get new_artisan_url
    assert_response :success
  end

  test "should create artisan" do
    assert_difference("Artisan.count") do
      post artisans_url, params: { artisan: { admin_id: @artisan.admin_id, email: @artisan.email, password_digest: @artisan.password_digest, store_name: @artisan.store_name } }
    end

    assert_redirected_to artisan_url(Artisan.last)
  end

  test "should show artisan" do
    get artisan_url(@artisan)
    assert_response :success
  end

  test "should get edit" do
    get edit_artisan_url(@artisan)
    assert_response :success
  end

  test "should update artisan" do
    patch artisan_url(@artisan), params: { artisan: { admin_id: @artisan.admin_id, email: @artisan.email, password_digest: @artisan.password_digest, store_name: @artisan.store_name } }
    assert_redirected_to artisan_url(@artisan)
  end

  test "should destroy artisan" do
    assert_difference("Artisan.count", -1) do
      delete artisan_url(@artisan)
    end

    assert_redirected_to artisans_url
  end
end
