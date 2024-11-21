# frozen_string_literal: true

class BoardsController < ApplicationController
  before_action :set_board, only: %i[show edit update destroy]

  # GET /boards or /boards.json
  def index
    @boards = Board.includes(:creator).order(id: :desc).page(params[:page]).per(10)
  end

  # GET /boards/1 or /boards/1.json
  def show
    @cols = @board.width
    @rows = @board.height
    @number_of_mines = @board.number_of_mines
  end

  # GET /boards/new
  def new
    @board = Board.new
  end

  # GET /boards/1/edit
  def edit; end

  # POST /boards or /boards.json
  def create
    @board = Board.new(board_params)

    respond_to do |format|
      if @board.save
        format.html { redirect_to @board, notice: 'Board was successfully created.' }
        format.json { render :show, status: :created, location: @board }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /boards/1 or /boards/1.json
  def update
    respond_to do |format|
      if @board.update(board_params)
        format.html { redirect_to @board, notice: 'Board was successfully updated.' }
        format.json { render :show, status: :ok, location: @board }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /boards/1 or /boards/1.json
  def destroy
    board_id = @board.id
    @board.delete

    DestroyBoardJob.perform_later(board_id)

    redirect_to all_boards_path, status: :see_other, notice: 'Board was successfully destroyed.'
  end

  def get_mines
    board = Board.find_by_id(params[:id])
    cells = board.cells

    @page = params[:page].to_i
    @per_page = params[:per_page].to_i
    max_page = (cells.count.to_f / @per_page).ceil
    offset = @page * @per_page

    @mines = cells.offset(offset).limit(@per_page).map { |a| { 'row': a.row, 'col': a.col, 'mine': true } }
    render json: { mines: @mines, max_page: max_page }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_board
    @board = Board.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def board_params
    params.require(:board).permit(:height, :width, :creator_id, :number_of_mines)
  end
end
