class AddAccessToNotes < ActiveRecord::Migration[7.2]
  def change
    add_column :notes, :access, :string
  end
end
