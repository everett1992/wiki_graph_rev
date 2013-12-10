class AddConnectedComponentToPages < ActiveRecord::Migration
  def change
    add_reference :pages, :connected_component, index: true

    create_table :connected_components
  end
end
