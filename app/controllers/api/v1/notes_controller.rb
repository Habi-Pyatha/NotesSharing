class Api::V1::NotesController < Api::V1::ApplicationController
  before_action :authenticate_user!

  def index
    render json: Note.all, each_serializer: NoteSerializer, status: :ok
  end

  def show
    begin
      @note= Note.find(params[:id])
      render json: @note, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Record not found" }, status: :not_found
    end
  end
end
