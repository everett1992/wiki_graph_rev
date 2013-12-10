class AddWikiAndCountToConnectedComponent < ActiveRecord::Migration
  def change
    change_table :connected_components do |t|
      t.references :wiki
    end

    reversible do |dir|
      dir.up do
        ConnectedComponent.all.each do |cc|
          cc.wiki = cc.pages.first.wiki
          cc.save
        end
      end
    end
  end
end
