//  PageControl

import UIKit

struct Coin: Codable {
  var name: String
  var icon: String
  var rank: Int
  var tradable: Bool
  var watchilist: Bool
  var new: Bool
  
  enum CodingKeys: String, CodingKey {
    case name = "Name"
    case icon = "Icon"
    case rank = "Rank"
    case tradable = "Tradable"
    case watchilist = "Watchlist"
    case new = "New"
  }
  
  static func allCoins() -> [Coin] {
    let url = Bundle.main.url(forResource: "Coins", withExtension: "plist")!
    let data = try! Data(contentsOf: url)
    let coins = try! PropertyListDecoder().decode([Coin].self, from: data)
    return coins
  }
}
