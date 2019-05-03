class StocksController < ApplicationController
  before_action :set_stock, only: [:show, :edit, :update, :destroy]

  def index
    @stocks = Stock.all
  end

  def show
  end

  def new
    ticker = params[:ticker].upcase
    stocks = StockQuote::Stock.raw_quote(ticker)

    if stocks.blank?
      render :json => { error: "ticker not found" }
    else
      @stock = Stock.new(
        symbol: stocks[ticker]["quote"]["symbol"],
        companyName: stocks[ticker]["quote"]["companyName"],
        primaryExchange: stocks[ticker]["quote"]["primaryExchange"],
        position: Position.last,
        sector: stocks[ticker]["quote"]["sector"],
        open: stocks[ticker]["quote"]["open"],
        close: stocks[ticker]["quote"]["close"],
        high: stocks[ticker]["quote"]["high"],
        low: stocks[ticker]["quote"]["low"],
        latestPrice: stocks[ticker]["quote"]["latestPrice"],
        latestTime: stocks[ticker]["quote"]["latestTime"],
        latestVolume: stocks[ticker]["quote"]["latestVolume"],
        iexRealTimePrice: stocks[ticker]["quote"]["iexRealTimePrice"],
        previousClose: stocks[ticker]["quote"]["previousClose"],
        changePercent: stocks[ticker]["quote"]["changePercent"],
        iexVolume: stocks[ticker]["quote"]["iexVolume"],
        avgTotalVolume: stocks[ticker]["quote"]["avgTotalVolume"],
        iexBidPrice: stocks[ticker]["quote"]["iexBidPrice"],
        iexBidSize: stocks[ticker]["quote"]["iexBidSize"],
        iexAskPrice: stocks[ticker]["quote"]["iexAskPrice"],
        iexAskSize: stocks[ticker]["quote"]["iexAskSize"],
        marketCap: ((stocks[ticker]["quote"]["marketCap"]).to_i / 1000000),
        peRatio: stocks[ticker]["quote"]["peRatio"],
        week52High: stocks[ticker]["quote"]["week52High"],
        week52Low: stocks[ticker]["quote"]["week52Low"],
        ytdChange: stocks[ticker]["quote"]["ytdChange"],
      )
      render :json => @stock
    end
  end

  def edit
  end

  def create
    @stock = Stock.new(stock_params)
    respond_to do |format|
      if @stock.save
        format.html { redirect_to @stock, notice: "Stock was successfully created." }
        format.json { render :show, status: :created, location: @stock }
      else
        format.html { render :new }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @stock.update(stock_params)
        format.html { redirect_to @stock, notice: "Stock was successfully updated." }
        format.json { render :show, status: :ok, location: @stock }
      else
        format.html { render :edit }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @stock.destroy
    respond_to do |format|
      format.html { redirect_to stocks_url, notice: "Stock was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_stock
    @stock = Stock.find(params[:id])
  end

  def stock_params
    params.require(:stock).permit(:quote, :companyName, :primaryExchange, :sector, :calculationPrice, :open, :close, :high, :low, :latestPrice, :latestSource, :latestTime, :latestVolume, :iexRealTimePrice, :previousClose, :changePercent, :iexVolume, :avgTotalVolume, :iexBidPrice, :iexBidsize, :iexAskPrice, :iexAskSize, :marketCap, :peRatio, :week52High, :week52Low, :ytdChange, :position_id)
  end
end
