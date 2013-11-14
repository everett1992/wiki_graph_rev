class CreateConnectedComponents < ActiveRecord::Migration
  def change
    create_table :connected_components do |t|
      t.references :wiki, index: true
    end
    change_table :pages do |t|
      t.references :connected_component
    end
  end
end
