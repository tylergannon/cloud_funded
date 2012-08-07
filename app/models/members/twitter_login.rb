class Members::TwitterLogin < ::Members::OmniauthLogin
  has_one :member
end
