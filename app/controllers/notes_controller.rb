class NotesController < ApplicationController
  before_action :set_note, only: [ :edit, :show, :update, :destroy ]
  before_action :authenticate_user!
  def index
    if params[:search].present?
      @notes=Note.search_by_title(params[:search])
      flash[:notice]=""
      unless @notes.any?
        @notes= Note.all.order(created_at: :desc)
        flash[:notice] = "No notes found for \"#{params[:search]}\". Showing all notes."

      end
    else
      @notes = Note.all.order(created_at: :desc)
    end
    # @notes= @notes.sample(@notes.length)
  end

  def new
    @note = Note.new
  end
  def create
    @note= Note.new(note_params)
    if @note.save
      respond_to do |format|
        format.html { redirect_to root_path, notice: "Note was added successfully." }
        format.turbo_stream
      end
    else
      flash[:alert]="Failed to Add Note."
      render :new, status: :unprocessable_entity
    end
  end
  def edit
    # @note=Note.find(params[:id])
  end
  def show
    # @note=Note.find(params[:id])
  end
  def update
    # @note=Note.find(params[:id])
    if @note.update(note_params)
      redirect_to root_path, notice: "Note was updated successfully."
    else
      flash[:alert]="Failed to Update Note."
      render :edit, status: :unprocessable_entity
    end
  end
  def destroy
    # @note=Note.find(params[:id])
    if @note.destroy
      flash[:notice]="Note was deleted successfully."
      respond_to do |format|
        format.html { redirect_to root_path }
        format.turbo_stream
      end
    else
      flash[:alert]="Failed to Delete Note."
      redirect_to root_path

    end
  end

  def remove_add_form
    respond_to do |format|
      format.turbo_stream
    end
  end

  def remove_content
    respond_to do |format|
      format.html { redirect_to root_path }
      format.turbo_stream
    end
  end

  private
  def note_params
    params.require(:note).permit(:title, :content, :access, note_images: []).merge(user_id: current_user.id)
  end

  def set_note
    begin
      @note=Note.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert]="Note not found!!!"
      redirect_to root_path
    end
  end
end
