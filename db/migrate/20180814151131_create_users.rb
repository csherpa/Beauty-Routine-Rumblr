class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |u|
      u.string :username
      u.string :password
      u.string :email
      u.string :firstname
      u.string :lastname
      u.date :birthday
    end
  end
end
