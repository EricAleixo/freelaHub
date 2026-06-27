class ProfileView < ApplicationRecord
  belongs_to :viewer, class_name: "Profile"
  belongs_to :viewed, class_name: "Profile"
end