class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title, index: true
      t.integer :page_ident, index: true
      t.integer :namespace
      t.references :wiki
    end
  end
end
