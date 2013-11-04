class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.integer :page_id
      t.references :wiki
    end
  end
end
