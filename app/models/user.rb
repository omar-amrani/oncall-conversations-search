class User < ApplicationRecord

  def self.find_or_create_from_auth_hash(auth_hash)
    if user.nil?
      return user = create(email: auth_hash.extra.raw_info["email"], name: auth_hash.extra.raw_info["name"])
    end
    return user = User.find_by(email: auth_hash.extra.raw_info["email"])
  end


  def full_name
    return "#{name}"
    "Anonymous"
  end

end
