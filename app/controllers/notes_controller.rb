class NotesController < ApplicationController
  before_action :set_note
  def index
    @notes = Note.all
  end

  def new
    @note = Note.new
  end
  def create
    @note= Note.new(note_params)
    if @note.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end
  def edit
    @note=Note.find(params[:id])
  end
  def show
    @note=Note.find(params[:id])
  end
  def update
    @note=Note.find(params[:id])
    if @note.update(note_params)
      redirect_to root_path
    else
      render :edit, status: :unprocessable_entity
    end
  end
  def destroy
    @note=Note.find(params[:id])
    if @note.destroy
      redirect_to root_path
    end
  end

  private
  def note_params
    params.require(:note).permit(:title, :content).merge(user_id: current_user.id)
  end

  def set_product
end
