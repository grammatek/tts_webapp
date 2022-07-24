class ProcessedFilesController < ApplicationController
  #skip_before_action :verify_authenticity_token
  #protect_from_forgery with: :null_session
  before_action :set_processed_file, only: [:show, :edit, :update, :destroy]

  def index
    @processed_files = ProcessedFile.ordered
  end

  def show
    @processed_file = ProcessedFile.find(params[:id])
  end

  def new
    #@processed_files = ProcessedFile.all
    @processed_file = ProcessedFile.new
  end

  def create
    @processed_file = ProcessedFile.new(file_params)

    if @processed_file.save
      #trigger_job
      respond_to do |format|
        format.html {redirect_to processed_files_path, notice: "Nýtt skjal sent í talgervingu"}
        format.turbo_stream
      end
      trigger_job(@processed_file)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @processed_file = ProcessedFile.find(params[:id])
  end

  def update
    if @processed_file.update(quote_params)
      redirect_to processed_files_path, notice: "Uppfærði skjal"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @processed_file = ProcessedFile.find(params[:id])
    @processed_file.destroy

    redirect_to root_path, status: :see_other
  end

  # Jobs
  def trigger_job(processed_file)
    p "going to process #{processed_file.name}"
    FileProcessingJob.perform_later(processed_file.id)
  end

  private

  def set_processed_file
    @processed_file = ProcessedFile.find(params[:id])
  end

  def file_params
    params.require(:processed_file).permit(:name, :snippet, :text_type, :text_file)
  end
end
