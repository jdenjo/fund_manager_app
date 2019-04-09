# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

PASSWORD = "supersecret"

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

roles = ["PM", "Analyst"]

10.times do
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
funds = ["Fund A", "Fund B", "Fund C", "Fund D", "Fund E"]

tickers = [
  "NASDAQ :AAPL",
  "NASDAQ: GOOG",
  "NASDAQ: AMZN",
  "NASDAQ: MSFT",
  "NASDAQ: INTC",
  "NYSE: BAC",
  "NASDAQ: NFLX",
  "NASDAQ: TSLA",
  "NASDAQ: GOOGL",
  "NYSE: GE",
  "NYSE: NKE",
  "NYSE: ACB",
  "NYSE: BRK.A",
  "NYSE: XOM",
  "NYSE: WMT",
  "NYSE: LUV",
  "NYSE: C",
  "NASDAQ: QQQ",
  "NYSE: BRK.B",
  "NASDAQ: AMD",
  "NYSE: S",
  "NYSE: TTM",
  "NYSE: DIS",
  "NYSE: PFE",
  "NYSE: BA",
  "NYSE: BABA",
  "NYSE: CHK",
  "NYSE: HPQ",
  "NASDAQ: TXN",
  "NYSE: NIO",
  "NYSE: MMM",
  "NASDAQ: NVDA",
  "NASDAQ: CMCSA",
  "NYSE: TGT",
  "NYSE: VZ",
  "NYSE: ECA",
  "NASDAQ: SYMC",
  "NYSE: MRK",
  "NYSE: A",
  "NASDAQ: BIDU",
  "NYSE: PBR",
  "NYSE: NOK",
  "NYSE: BMY",
  "NYSE: WFC",
  "NASDAQ: ROKU",
  "NASDAQ: CSCO",
  "NYSE: SLG",
]

fundAmount = funds.length - 1
users = User.all

fundAmount.times do |i|
  inception = Faker::Date.backward(365 * 5)

  Fund.create(
    name: funds[i],
    strategy: strategies[i],
    user: users.sample,
    AUM: rand(500000000..2000000000),
    inception: inception,
  )

  10.times do
    tickerData = tickers.sample
    userData = users.sample

    Position.create(
      ticker: tickerData,
      user: users.sample,
      fund: Fund.last,
    )

    10.times do
      Transaction.create(
        ticker: tickerData,
        price: rand(10..100),
        shares: rand(1000..100000),
        position: Position.last,
        reason: "Catalyst upcoming",
      )
    end
  end
end
