class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |p|
      p.string :post_name
      p.string :post_info
      p.integer :user_id
    end
  end
end
