module Releaf::Permissions
  class User < ActiveRecord::Base
    self.table_name = 'releaf_users'

    # store UI settings with RailsSettings
    include RailsSettings::Extend

    # Include default devise modules. Others available are:
    # :token_authenticatable, :confirmable,
    # :lockable, :timeoutable and :omniauthable
    # :registerable
    devise :database_authenticatable, :rememberable, :trackable, :validatable
    validates_presence_of :name, :surname, :role, :locale
    belongs_to :role

    def releaf_title
      [name, surname].join(' ')
    end
  end
end
