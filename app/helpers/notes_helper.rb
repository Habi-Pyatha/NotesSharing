module NotesHelper
  def can_edit_note?(note)
    current_user&.id == note.user_id
  end
end
