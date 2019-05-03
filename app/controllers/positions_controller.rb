class PositionsController < ApplicationController
  before_action :set_position, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @positions = Position.where(user_id: params[:id] , status: "ACTIVE")
    @funds = Fund.all
    tickers = @positions.pluck(:ticker).join(", ")
    @stocks = StockQuote::Stock.raw_quote(tickers)
  end

  def show
    @ticker = Position.find(params[:id]).ticker
    @stockData = StockQuote::Stock.chart(@ticker, 'ytd')
  end

  def new
    @position = Position.new
  end

  def edit
  end

  def create
    @position = Position.new(position_params)
    @position.user = User.find(current_user)

    respond_to do |format|
      if @position.save
        format.html { redirect_to @position, notice: "Position was successfully created." }
        format.json { render :show, status: :created, location: @position }
      else
        format.html { render :new }
        format.json { render json: @position.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @position.update(position_params)
        format.html { redirect_to @position, notice: "Position was successfully updated." }
        format.json { render :show, status: :ok, location: @position }
      else
        format.html { render :edit }
        format.json { render json: @position.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @position.destroy
    respond_to do |format|
      format.html { redirect_to positions_url, notice: "Position was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_position
    @position = Position.find(params[:id])
  end

  def position_params
    params.require(:position).permit(:ticker, :termination, :user, :fund_id)
  end
end
