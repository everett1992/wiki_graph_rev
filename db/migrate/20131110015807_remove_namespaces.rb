class RemoveNamespaces < ActiveRecord::Migration
  def change
      remove_column :pages, :namespace
  end
end
