module UsersHelper
  def gender_select(user, current_gender)
    user.profile.gender == current_gender ? 'btn-primary' : 'btn-secondary'
  end
end
