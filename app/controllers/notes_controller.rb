class NotesController < ApplicationController
  NOTES_PER_PAGE = 20

  before_action :set_note, only: %i[ show edit update destroy ]

  # GET /notes or /notes.json
  def index
    @page = [ params.fetch(:page, 1).to_i, 1 ].max
    notes = Note.order(created_at: :desc).limit(NOTES_PER_PAGE + 1).offset((@page - 1) * NOTES_PER_PAGE)
    @has_next_page = notes.length > NOTES_PER_PAGE
    @notes = notes.first(NOTES_PER_PAGE)
  end

  # GET /notes/1 or /notes/1.json
  def show
    fresh_when @note
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes or /notes.json
  def create
    @note = Note.new(note_params)

    respond_to do |format|
      if @note.save
        format.html { redirect_to @note, notice: "Note was successfully created." }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @note.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /notes/1 or /notes/1.json
  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to @note, notice: "Note was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @note.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /notes/1 or /notes/1.json
  def destroy
    @note.destroy!

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(dom_id(@note)) }
      format.html { redirect_to notes_path, notice: "Note was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def note_params
      params.expect(note: [ :title, :content ])
    end
end
