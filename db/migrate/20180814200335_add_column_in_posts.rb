class AddColumnInPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :image, :integer
  end
end
