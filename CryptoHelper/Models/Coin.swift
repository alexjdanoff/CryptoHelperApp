//
//  Coin.swift
//  CryptoHelper
//
//  Created by Alexandru Jdanov on 07.09.2022.


import SwiftUI
import RealmSwift

final class Coin: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name = ""
    @Persisted var prices = RealmSwift.List<Double>()
    @Persisted var temporalPrices = RealmSwift.List<Double>()
    @Persisted var stockPrices = RealmSwift.List<StockPrice>()
    @Persisted var code = ""
    @Persisted var imageUrl = ""
    @Persisted var priceMovement: PriceMovement = .stable

    enum PriceMovement: String, PersistableEnum {
        case up, stable, down
        
        var color: Color {
            switch self {
            case .up:
                return Color("customGreen")
                
            case .stable:
                return Color.clear
                
            case .down:
                return Color("customRed")
            }
        }
        
        var textColor: Color {
            switch self {
            case .up:
                return Color.white
                
            case .stable:
                return Color("customBlack")
                
            case .down:
                return Color.white
            }
        }
    }
    
    convenience init(name: String,
                     price: Double,
                     code: String,
                     imageUrl: String,
                     priceMoviment: PriceMovement) {
        self.init()
        self.name = name
        self.prices.append(price)
        self.code = code
        self.imageUrl = imageUrl
        self.priceMovement = priceMoviment
    }
}
