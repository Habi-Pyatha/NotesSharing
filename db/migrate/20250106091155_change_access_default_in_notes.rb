class ChangeAccessDefaultInNotes < ActiveRecord::Migration[7.2]
  def change
    change_column_default :notes, :access, "public"
  end
end
