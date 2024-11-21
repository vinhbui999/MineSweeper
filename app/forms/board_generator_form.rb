# frozen_string_literal: true

class BoardGeneratorForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :email
  attribute :width
  attribute :height
  attribute :number_of_mines
  attribute :name

  validates :email, :name, presence: true, length: { maximum: 50 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, if: proc { |a| a.email.present? }
  validates :width, :height, :number_of_mines, presence: true, numericality: { greater_than: 0 }
  validate :valid_input_mines

  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      creator = Creator.new(email: email, board_attributes: { width: width.to_i, height: height.to_i, number_of_mines: number_of_mines.to_i, name: name })

      if creator.save
        board = creator.board

        # GenerateCellsWithMinesService.call(board)
        return board
      end

      errors.merge!(creator.errors)
      raise ActiveRecord::Rollback
    end
  end

  private

  def valid_input_mines
    return unless number_of_mines.present?

    errors.add(:number_of_mines, 'invalid number of Mines') if number_of_mines.to_i > (height.to_i * width.to_i)
  end
end
