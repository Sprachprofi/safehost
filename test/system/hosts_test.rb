require "application_system_test_case"

class HostsTest < ApplicationSystemTestCase
  setup do
    @host = hosts(:one)
  end

  test "visiting the index" do
    visit hosts_url
    assert_selector "h1", text: "Hosts"
  end

  test "creating a Host" do
    visit hosts_url
    click_on "New Host"

    fill_in "Address", with: @host.address
    fill_in "City", with: @host.city
    fill_in "Country", with: @host.country
    fill_in "Description", with: @host.description
    fill_in "Languages", with: @host.languages
    fill_in "Max duration", with: @host.max_duration
    fill_in "Max sleeps", with: @host.max_sleeps
    fill_in "Optimal no guests", with: @host.optimal_no_guests
    fill_in "Other comments", with: @host.other_comments
    fill_in "Postal code", with: @host.postal_code
    fill_in "Sleep conditions", with: @host.sleep_conditions
    fill_in "User", with: @host.user_id
    fill_in "Which guests", with: @host.which_guests
    fill_in "Which hosts", with: @host.which_hosts
    click_on "Create Host"

    assert_text "Host was successfully created"
    click_on "Back"
  end

  test "updating a Host" do
    visit hosts_url
    click_on "Edit", match: :first

    fill_in "Address", with: @host.address
    fill_in "City", with: @host.city
    fill_in "Country", with: @host.country
    fill_in "Description", with: @host.description
    fill_in "Languages", with: @host.languages
    fill_in "Max duration", with: @host.max_duration
    fill_in "Max sleeps", with: @host.max_sleeps
    fill_in "Optimal no guests", with: @host.optimal_no_guests
    fill_in "Other comments", with: @host.other_comments
    fill_in "Postal code", with: @host.postal_code
    fill_in "Sleep conditions", with: @host.sleep_conditions
    fill_in "User", with: @host.user_id
    fill_in "Which guests", with: @host.which_guests
    fill_in "Which hosts", with: @host.which_hosts
    click_on "Update Host"

    assert_text "Host was successfully updated"
    click_on "Back"
  end

  test "destroying a Host" do
    visit hosts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Host was successfully destroyed"
  end
end
