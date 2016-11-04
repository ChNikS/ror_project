class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.text :body
      t.integer :commentable_id
      t.string :commentable_type
      t.references :user, index: true
      t.timestamps
    end
    
    add_index :comments, [:commentable_id, :commentable_type]
    add_foreign_key :comments, :users
  end
end
