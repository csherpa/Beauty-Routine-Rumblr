class RemovePostsImagecolumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :posts, :image, :integer
  end
end
