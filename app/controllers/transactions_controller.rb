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
  end

  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions
  # POST /transactions.json
  def create
    fund = Fund.find(transaction_params["fund"])
    cost = transaction_params["price"].to_f * transaction_params["shares"].to_f

    @transaction = Transaction.new(
      shares: transaction_params["shares"],
      price: transaction_params["price"],
      reason: transaction_params["reason"],
      ticker: transaction_params["ticker"],
      cost: cost,
      fund: fund,
      user: current_user,
    )

    if Position.where(ticker: @transaction.ticker, fund: @transaction.fund).exists?
      @transaction.position = Position.where(ticker: @transaction.ticker, fund: @transaction.fund)[0]
    else
      Position.create(
        ticker: @transaction.ticker,
        sector: "Test",
        user_id: User.last.id,
        fund: @transaction.fund,
        status: "active",
      )
      @transaction.position = Position.last
    end

    respond_to do |format|
      if @transaction.save

        # update the shares and price of the position
        position = @transaction.position
        position.totalShares = (position.totalShares.to_f + @transaction.shares)
        position.averageCost = (position.averageCost.to_f + @transaction.cost)
        position.averagePrice = (position.averageCost.to_f / position.totalShares.to_f)
        position.save

        #check if the position has no shares left
        if position.totalShares <= 0
          position.status = "inactive"
        end

        format.html { redirect_to "/funds/#{fund.id}", notice: "Transaction was successfully executed." }
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
    params.require(:transaction).permit(:fund, :shares, :price, :status, :reason, :position_id, :ticker)
  end
end
