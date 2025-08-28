class OptionsController < ApplicationController
  before_action :set_option, only: %i[ show edit update destroy ]

  def index
    @options = Option.all
  end

  def show
  end

  def new
    @option = Option.new
  end

  def edit
  end

  def create
    @option = Option.new(option_params)

    respond_to do |format|
      if @option.save
        format.html { redirect_to @option }
        format.json { render :show, status: :created, location: @option }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @option.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @option.update(option_params)
        format.html { redirect_to @option, notice: "Option was successfully updated." }
        format.json { render :show, status: :ok, location: @option }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @option.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @option.destroy!

    respond_to do |format|
      format.html { redirect_to questions_path, status: :see_other }
      format.json { head :no_content }
    end
  end

  private

    def set_option
      @option = Option.find(params.expect[:id])
    end

    def option_params
      params.expect(option: [ :name, :correct, :question_id ])
    end
end
