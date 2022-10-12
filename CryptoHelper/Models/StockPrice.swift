//
//  StockPrice.swift
//  CryptoHelper
//
//  Created by Alexandru Jdanov on 22.09.2022.
//

import SwiftUI
import RealmSwift

final class StockPrice: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var timestamp: Date
    @Persisted var open = 0.0
    @Persisted var high = 0.0
    @Persisted var low = 0.0
    @Persisted var close = 0.0
    
    convenience init(open: Double,
                     high: Double,
                     low: Double,
                     close: Double) {
        self.init()
        self.open = open
        self.high = high
        self.low = low
        self.close = close
    }
}

extension StockPrice {
    var isClosingHigher: Bool {
        self.open < self.close
    }
}
