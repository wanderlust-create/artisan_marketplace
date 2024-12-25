require 'application_system_test_case'

class ArtisansTest < ApplicationSystemTestCase
  setup do
    @artisan = artisans(:one)
  end

  test 'visiting the index' do
    visit artisans_url
    assert_selector 'h1', text: 'Artisans'
  end

  test 'should create artisan' do
    visit artisans_url
    click_on 'New artisan'

    fill_in 'Admin', with: @artisan.admin_id
    fill_in 'Email', with: @artisan.email
    fill_in 'Password digest', with: @artisan.password_digest
    fill_in 'Store name', with: @artisan.store_name
    click_on 'Create Artisan'

    assert_text 'Artisan was successfully created'
    click_on 'Back'
  end

  test 'should update Artisan' do
    visit artisan_url(@artisan)
    click_on 'Edit this artisan', match: :first

    fill_in 'Admin', with: @artisan.admin_id
    fill_in 'Email', with: @artisan.email
    fill_in 'Password digest', with: @artisan.password_digest
    fill_in 'Store name', with: @artisan.store_name
    click_on 'Update Artisan'

    assert_text 'Artisan was successfully updated'
    click_on 'Back'
  end

  test 'should destroy Artisan' do
    visit artisan_url(@artisan)
    click_on 'Destroy this artisan', match: :first

    assert_text 'Artisan was successfully destroyed'
  end
end
