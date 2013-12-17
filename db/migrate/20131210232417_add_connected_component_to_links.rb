class AddConnectedComponentToLinks < ActiveRecord::Migration
  def change
    add_reference :links, :connected_component, index: true

    reversible do |dir|
      dir.up do
        Link.find_each do |link|
          link.connected_component_id = link.from.connected_component_id if link.from.connected_component_id == link.to.connected_component_id
          link.save
        end
      end
    end
  end
end
