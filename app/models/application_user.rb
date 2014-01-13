class ApplicationUser
    attr_accessor :twitter_user_id, :facebook_user_id, :user_name, :email
    def self.sharedUser
        Dispatch.once { @instance ||= new }
        @instance
    end

    def save
        App::Persistence['twitter_user_id'] = @twitter_user_id
        App::Persistence['facebook_user_id'] = @facebook_user_id
        App::Persistence['user_name'] = @user_name
        App::Persistence['email'] = @email
    end
    def load
        self.twitter_user_id  = App::Persistence['twitter_user_id']
        self.facebook_user_id = App::Persistence['facebook_user_id']
        self.user_name        = App::Persistence['user_name']
        self.email            = App::Persistence['email']
    end

end
