require "application_system_test_case"

class ProfileSkillsTest < ApplicationSystemTestCase
  setup do
    @profile_skill = profile_skills(:one)
  end

  test "visiting the index" do
    visit profile_skills_url
    assert_selector "h1", text: "Profile skills"
  end

  test "should create profile skill" do
    visit profile_skills_url
    click_on "New profile skill"

    fill_in "Level", with: @profile_skill.level
    fill_in "Profile", with: @profile_skill.profile_id
    fill_in "Skill", with: @profile_skill.skill_id
    click_on "Create Profile skill"

    assert_text "Profile skill was successfully created"
    click_on "Back"
  end

  test "should update Profile skill" do
    visit profile_skill_url(@profile_skill)
    click_on "Edit this profile skill", match: :first

    fill_in "Level", with: @profile_skill.level
    fill_in "Profile", with: @profile_skill.profile_id
    fill_in "Skill", with: @profile_skill.skill_id
    click_on "Update Profile skill"

    assert_text "Profile skill was successfully updated"
    click_on "Back"
  end

  test "should destroy Profile skill" do
    visit profile_skill_url(@profile_skill)
    accept_confirm { click_on "Destroy this profile skill", match: :first }

    assert_text "Profile skill was successfully destroyed"
  end
end
