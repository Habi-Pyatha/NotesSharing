class NotesController < ApplicationController
  before_action :set_note, only: [ :edit, :show, :update, :destroy ]
  before_action :authenticate_user!
  def index
    @notes = Note.all
    @notes= @notes.sample(@notes.length)
  end

  def new
    @note = Note.new
  end
  def create
    @note= Note.new(note_params)
    if @note.save
      redirect_to root_path, notice: "Note was added successfully."
    else
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
      render :edit, status: :unprocessable_entity
    end
  end
  def destroy
    # @note=Note.find(params[:id])
    if @note.destroy
      redirect_to root_path
    end
  end

  private
  def note_params
    params.require(:note).permit(:title, :content).merge(user_id: current_user.id)
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
