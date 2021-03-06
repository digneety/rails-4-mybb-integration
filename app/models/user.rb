class User < ActiveRecord::Base

  def self.logged_in? sid_cookie
    if session = User::MyBBSessionTable.find(sid_cookie)
      session.user
    end
  end

  def self.banned? sid_cookie
    if user = self.logged_in?(sid_cookie)
      User::MyBBBannedTable.exists? user: user
    end
  end

  class MyBBUserTable < ActiveRecord::Base
    
    if Rails.env.production?
      establish_connection :mybb_database_production
    else
      establish_connection :mybb_database_development
    end
    
    self.table_name = :mybb_users
    self.primary_key = :uid

    has_one :session, class_name: "MyBBSessionTable", foreign_key: :sid
    has_one :banned, class_name: "MyBBBannedTable", foreign_key: :uid
  end

  class MyBBSessionTable < ActiveRecord::Base

    if Rails.env.production?
      establish_connection :mybb_database_production
    else
      establish_connection :mybb_database_development
    end

    self.table_name = :mybb_sessions
    self.primary_key = :sid

    belongs_to :user, class_name: "MyBBUserTable", foreign_key: :uid
  end

  class MyBBBannedTable < ActiveRecord::Base

    if Rails.env.production?
      establish_connection :mybb_database_production
    else
      establish_connection :mybb_database_development
    end

    self.table_name = :mybb_banned

    belongs_to :user, class_name: "MyBBUserTable", foreign_key: :uid
  end


end
