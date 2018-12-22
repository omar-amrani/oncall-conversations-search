class User < ApplicationRecord

  def self.find_or_create_from_auth_hash(auth_hash)
    return user = User.find_by(email: auth_hash.extra.raw_info["email"])
    if user.nil?
      return user = create(email: auth_hash.extra.raw_info["email"], name: auth_hash.extra.raw_info["name"])
    end

  end


  def full_name
    return "#{name}"
    "Anonymous"
  end

end
