# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

PASSWORD = "supersecret"

Stock.destroy_all
Transaction.destroy_all
Position.destroy_all
Fund.destroy_all
User.destroy_all

super_user = User.create(
  first_name: "John",
  last_name: "Snow",
  email: "js@winterfell.gov",
  password: PASSWORD,
  admin: true,
  role: "PM",
)

reasons = [
  "Earnings coming up",
  "Increased newsflow",
  "Trimming before earnings",
  "Feel consensus estimates will come up",
  "Earnings over trimming",
  "Locking in profit after rise",
  "Trade is too crowded, trimming",
  "Excessive fall, increasing position",
  "Excessive rise, trimming position",
  "Investor day in the next few weeks",
  "Distressed event in the news",
]

roles = ["PM", "Analyst"]
type = ["BUY"]

3.times do
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  User.create(
    first_name: first_name,
    last_name: last_name,
    email: "#{first_name.downcase}.#{last_name.downcase}@example.com",
    password: PASSWORD,
    role: roles.sample,
  )
end

strategies = ["Activist", "Long Short Alpha", "Fundamental Value", "small mid caps", "Alpha capture", "Distressed", "Fundamental Growth", "Multi-strategy"]

stocks = StockQuote::Stock.raw_quote(
  "GOOG,
    AMZN,
    MSFT,
    NFLX,
    TSLA,
    GOOGL,
    GE,
    NKE,
    AMD,
    BABA,
    ROKU,
    INTC,
    PCG,
    BAC,
    XOM,
    VZ,
    GE,
    QCOM,
    PFE,
    S,
    NOK,
    T"
)

positionTypes = ["LONG", "SHORT"]

users = User.all

4.times do |i|
  inception = Faker::Date.backward(365 * 5)

  #reload new tickers for each fund
  @tickers = [
    "GOOG",
    "AMZN",
    "MSFT",
    "NFLX",
    "TSLA",
    "GOOGL",
    "GE",
    "NKE",
    "AMD",
    "BABA",
    "ROKU",
    "INTC",
    "PCG",
    "BAC",
    "XOM",
    "VZ",
    "GE",
    "QCOM",
    "PFE",
    "S",
    "NOK",
    "T",
  ]

  Fund.create(
    name: Faker::Space.moon + " Fund",
    strategy: strategies[i],
    pm: users.sample,
    AUM: 1000000000,
    inception: inception,
  )

  rand(10..20).times do
    @tickers.shuffle!
    tickerData = @tickers.last
    @tickers.pop
    userData = users.sample

    if stocks[tickerData]["quote"]["sector"] != nil
      sector = stocks[tickerData]["quote"]["sector"]
    else
      sector = "diversified"
    end

    positionType = positionTypes.sample
    positionType == "LONG" ? orderType = "BUY" : orderType = "SHORT"

    Position.create(
      ticker: tickerData,
      user: userData,
      fund: Fund.last,
      status: "ACTIVE",
      sector: sector,
      positionType: positionType,
    )

    rand(1..5).times do
      shares = rand(10000000..20000000) / stocks[tickerData]["quote"]["latestPrice"]
      price = stocks[tickerData]["quote"]["latestPrice"] * rand(0.85..1.1)
      cost = price.to_f * shares.to_f

      Transaction.create(
        ticker: tickerData,
        price: price,
        shares: shares,
        cost: cost,
        position: Position.last,
        reason: reasons.sample,
        status: "ACTIVE",
        created_at: Faker::Date.backward(90),
        fund: Fund.last,
        user: userData,
        tradeType: orderType,
      )

      position = Position.last
      position.totalShares = (position.totalShares.to_f + shares)
      position.averageCost = (position.averageCost.to_f + cost)
      position.averagePrice = (position.averageCost.to_f / position.totalShares.to_f)
      position.save
    end
  end
end

for i in 0..(@tickers.length - 1)
  if !(stocks[@tickers[i]] == nil)
    Stock.create(
      symbol: stocks[@tickers[i]]["quote"]["symbol"],
      companyName: stocks[@tickers[i]]["quote"]["companyName"],
      primaryExchange: stocks[@tickers[i]]["quote"]["primaryExchange"],
      position: Position.last,
      sector: stocks[@tickers[i]]["quote"]["sector"],
      open: stocks[@tickers[i]]["quote"]["open"],
      close: stocks[@tickers[i]]["quote"]["close"],
      high: stocks[@tickers[i]]["quote"]["high"],
      low: stocks[@tickers[i]]["quote"]["low"],
      latestPrice: stocks[@tickers[i]]["quote"]["latestPrice"],
      latestTime: stocks[@tickers[i]]["quote"]["latestTime"],
      latestVolume: stocks[@tickers[i]]["quote"]["latestVolume"],
      iexRealTimePrice: stocks[@tickers[i]]["quote"]["iexRealTimePrice"],
      previousClose: stocks[@tickers[i]]["quote"]["previousClose"],
      changePercent: stocks[@tickers[i]]["quote"]["changePercent"],
      iexVolume: stocks[@tickers[i]]["quote"]["iexVolume"],
      avgTotalVolume: stocks[@tickers[i]]["quote"]["avgTotalVolume"],
      iexBidPrice: stocks[@tickers[i]]["quote"]["iexBidPrice"],
      iexBidSize: stocks[@tickers[i]]["quote"]["iexBidSize"],
      iexAskPrice: stocks[@tickers[i]]["quote"]["iexAskPrice"],
      iexAskSize: stocks[@tickers[i]]["quote"]["iexAskSize"],
      marketCap: ((stocks[@tickers[i]]["quote"]["marketCap"]).to_i / 1000000),
      peRatio: stocks[@tickers[i]]["quote"]["peRatio"],
      week52High: stocks[@tickers[i]]["quote"]["week52High"],
      week52Low: stocks[@tickers[i]]["quote"]["week52Low"],
      ytdChange: stocks[@tickers[i]]["quote"]["ytdChange"],
    )
  end
end
