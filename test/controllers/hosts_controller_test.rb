require 'test_helper'

class HostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @host = hosts(:one)
  end

  test "should get index" do
    get hosts_url
    assert_response :success
  end

  test "should get new" do
    get new_host_url
    assert_response :success
  end

  test "should create host" do
    assert_difference('Host.count') do
      post hosts_url, params: { host: { address: @host.address, city: @host.city, country: @host.country, description: @host.description, languages: @host.languages, max_duration: @host.max_duration, max_sleeps: @host.max_sleeps, optimal_no_guests: @host.optimal_no_guests, other_comments: @host.other_comments, postal_code: @host.postal_code, sleep_conditions: @host.sleep_conditions, user_id: @host.user_id, which_guests: @host.which_guests, which_hosts: @host.which_hosts } }
    end

    assert_redirected_to host_url(Host.last)
  end

  test "should show host" do
    get host_url(@host)
    assert_response :success
  end

  test "should get edit" do
    get edit_host_url(@host)
    assert_response :success
  end

  test "should update host" do
    patch host_url(@host), params: { host: { address: @host.address, city: @host.city, country: @host.country, description: @host.description, languages: @host.languages, max_duration: @host.max_duration, max_sleeps: @host.max_sleeps, optimal_no_guests: @host.optimal_no_guests, other_comments: @host.other_comments, postal_code: @host.postal_code, sleep_conditions: @host.sleep_conditions, user_id: @host.user_id, which_guests: @host.which_guests, which_hosts: @host.which_hosts } }
    assert_redirected_to host_url(@host)
  end

  test "should destroy host" do
    assert_difference('Host.count', -1) do
      delete host_url(@host)
    end

    assert_redirected_to hosts_url
  end
end
