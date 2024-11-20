# frozen_string_literal: true

class CreatorsController < ApplicationController
  before_action :set_creator, only: %i[show edit update destroy]

  # GET /creators or /creators.json
  def index
    @creators = Creator.all
  end

  # GET /creators/1 or /creators/1.json
  def show; end

  # GET /creators/new
  def new
    # @creator = Creator.new
    @board_generator = BoardGeneratorForm.new
    @ten_boards = Board.order(id: :desc).first(10)
    render :new, locals: { ten_boards: @ten_boards || [] }
  end

  # GET /creators/1/edit
  def edit; end

  # POST /creators or /creators.json
  def create
    @board_generator = BoardGeneratorForm.new(board_generator_params)
    generated_board = @board_generator.save
    if generated_board
      GenerateCellsWithMinesService.call(generated_board)
      redirect_to generated_board
    else
      render :new, locals: { ten_boards: Board.order(id: :desc).first(10) || [] }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_creator
    @creator = Creator.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def creator_params
    params.require(:creator).permit(:email)
  end

  def board_generator_params
    params.require(:board_generator_form).permit(:email, :height, :width, :number_of_mines, :name)
  end
end
