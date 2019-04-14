class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def addTrim
    id = params[:id]
    @position = Position.find(id)
  end

  # GET /transactions
  # GET /transactions.json
  def index
    @transactions = Transaction.where(user_id: current_user.id)
  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
    @searchTicker = params["ticker"]
  end

  `                                                                                                                                                                             AAAA1aq-`
  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions
  # POST /transactions.json
  def create
    fund = Fund.find(transaction_params["fund"])
    cost = transaction_params["price"].to_f * transaction_params["shares"].to_f.abs

    shares = 0

    if transaction_params["tradeType"] == "SHORT"
      shares = transaction_params["shares"].to_f * -1
    else
      shares = transaction_params["shares"]
    end

    byebug

    @transaction = Transaction.new(
      shares: shares,
      price: transaction_params["price"],
      priceType: transaction_params["priceType"],
      reason: transaction_params["reason"],
      ticker: transaction_params["ticker"],
      traderPrice: transaction_params["price"], #this defaults to market price for now
      tradeType: transaction_params["tradeType"],
      status: "Executing",
      cost: cost,
      fund: fund,
      user: User.find(transaction_params["user"]),
      traderInstruction: transaction_params["traderInstruction"],
      sector: transaction_params["sector"],
    )

    # update the shares and price of the position
    if @transaction.tradeType == "BUY"
      positionType = "LONG"
    else
      positionType = "SHORT"
    end

    if Position.where(ticker: @transaction.ticker, fund: @transaction.fund).exists?
      @transaction.position = Position.where(ticker: @transaction.ticker, fund: @transaction.fund)[0]
      #TODO Reject if its a long position when an existing short is made
      #regulation wise you cant long and short a position at the same time
    else
      Position.create(
        ticker: @transaction.ticker,
        sector: @transaction.sector,
        user_id: User.last.id,
        fund: @transaction.fund,
        status: "active",
        positionType: positionType,
      )
      @transaction.position = Position.last
    end

    position = @transaction.position

    respond_to do |format|
      if @transaction.save
        position.totalShares = (@transaction.position.totalShares.to_f + @transaction.shares)
        position.averageCost = (@transaction.position.averageCost.to_f + @transaction.cost)
        position.averagePrice = (@transaction.position.averageCost.to_f.abs / @transaction.position.totalShares.to_f.abs)
        position.save

        #check if the position has no shares left
        if @transaction.position.totalShares <= 0
          @transaction.position.status = "inactive"
        end

        format.html { redirect_to "/funds/#{fund.id}", notice: "#{@transaction.tradeType} order for #{@transaction.shares} of  #{@transaction.ticker} was successfully entered into the system." }
        format.json { render :show, status: :created, location: @transaction }
      else
        format.html { render :new }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transactions/1
  # PATCH/PUT /transactions/1.json
  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to @transaction, notice: "Transaction was successfully updated." }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1
  # DELETE /transactions/1.json
  def destroy
    @transaction.destroy
    respond_to do |format|
      format.html { redirect_to transactions_url, notice: "Transaction was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def transaction_params
    params.require(:transaction).permit(:fund, :sector, :priceType, :tradeType, :traderInstruction, :user, :shares, :price, :status, :reason, :position_id, :ticker)
  end
end
