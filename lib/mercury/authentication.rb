module Mercury
  module Authentication

    def can_edit?
      member_signed_in? && current_member.admin
    end
  end
end
