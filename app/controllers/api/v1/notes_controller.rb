class Api::V1::NotesController < Api::V1::ApplicationController
  before_action :authenticate_user!

  def index
    render json: Note.all
  end
end
