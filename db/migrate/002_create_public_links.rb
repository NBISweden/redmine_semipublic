class CreatePublicLinks < ActiveRecord::Migration
  def change
    create_table :public_links do |t|
      t.integer :issue_id
      t.string :url
      t.boolean :active, :default => false
    end
  end
end
