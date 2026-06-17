require "test_helper"

class ProfileSkillsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @profile_skill = profile_skills(:one)
  end

  test "should get index" do
    get profile_skills_url
    assert_response :success
  end

  test "should get new" do
    get new_profile_skill_url
    assert_response :success
  end

  test "should create profile_skill" do
    assert_difference("ProfileSkill.count") do
      post profile_skills_url, params: { profile_skill: { level: @profile_skill.level, profile_id: @profile_skill.profile_id, skill_id: @profile_skill.skill_id } }
    end

    assert_redirected_to profile_skill_url(ProfileSkill.last)
  end

  test "should show profile_skill" do
    get profile_skill_url(@profile_skill)
    assert_response :success
  end

  test "should get edit" do
    get edit_profile_skill_url(@profile_skill)
    assert_response :success
  end

  test "should update profile_skill" do
    patch profile_skill_url(@profile_skill), params: { profile_skill: { level: @profile_skill.level, profile_id: @profile_skill.profile_id, skill_id: @profile_skill.skill_id } }
    assert_redirected_to profile_skill_url(@profile_skill)
  end

  test "should destroy profile_skill" do
    assert_difference("ProfileSkill.count", -1) do
      delete profile_skill_url(@profile_skill)
    end

    assert_redirected_to profile_skills_url
  end
end
