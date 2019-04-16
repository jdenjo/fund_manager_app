class FundsController < ApplicationController
  before_action :set_fund, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /funds
  # GET /funds.json
  def index
    @funds = Fund.all
    @positions = Position.where(user_id: current_user.id, status: "ACTIVE")
    tickers = @positions.pluck(:ticker).join(", ")
    @stocks = StockQuote::Stock.raw_quote(tickers)
  end

  # GET /funds/1
  # GET /funds/1.json
  def show
    @fund = Fund.find(params[:id])
    @positions = @fund.positions.where.not(totalShares: 0)
    tickers = @fund.positions.pluck(:ticker).join(", ")
    @stocks = StockQuote::Stock.raw_quote(tickers)
  end

  # GET /funds/new
  def new
    @fund = Fund.new
  end

  # GET /funds/1/edit
  def edit
  end

  # POST /funds
  # POST /funds.json
  def create
    @fund = Fund.new(fund_params)

    respond_to do |format|
      if @fund.save
        format.html { redirect_to @fund, notice: "Fund was successfully created." }
        format.json { render :show, status: :created, location: @fund }
      else
        format.html { render :new }
        format.json { render json: @fund.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /funds/1
  # PATCH/PUT /funds/1.json
  def update
    respond_to do |format|
      if @fund.update(fund_params)
        format.html { redirect_to @fund, notice: "Fund was successfully updated." }
        format.json { render :show, status: :ok, location: @fund }
      else
        format.html { render :edit }
        format.json { render json: @fund.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /funds/1
  # DELETE /funds/1.json
  def destroy
    @fund.destroy
    respond_to do |format|
      format.html { redirect_to funds_url, notice: "Fund was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_fund
    @fund = Fund.find(params[:id])
    # @totals = {}
    # p @fund.positions[0].transactions
    # @fund.positions.each do |p|
    #   count = 0
    #   cost = 0
    #   share_total = 0
    #   @totals["#{p.id}"] = {}
    #   p.transactions.each do |t|
    #     cost += (t.shares * t.price)
    #     count += 1
    #     share_total += t.shares
    #   end
    #   @totals["#{p.id}"]["total"] = share_total
    #   @totals["#{p.id}"]["average"] = cost / share_total
    # end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def fund_params
    params.require(:fund).permit(:name, :strategy, :AUM, :inception, :user_id)
  end
end
