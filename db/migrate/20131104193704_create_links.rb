class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.references :to, index: true
      t.references :from, index: true
    end
  end
end
