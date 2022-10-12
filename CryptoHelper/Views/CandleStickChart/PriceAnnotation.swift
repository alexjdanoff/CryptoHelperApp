//
//  PriceAnnotation.swift
//  CryptoHelper
//
//  Created by Alexandru Jdanov on 09.10.2022.
//

import SwiftUI

struct PriceAnnotation: View {
    private var price: StockPrice
    
    init(for price: StockPrice) {
        self.price = price
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text(price.timestamp.formatted(date: .abbreviated, time: .standard))
                .foregroundColor(.secondary)
            
            HStack {
                Spacer()
                Text("O:").foregroundColor(.secondary)
                Text(price.open.formatPriceNumber())
                
                Text("C:").foregroundColor(.secondary)
                Text(price.close.formatPriceNumber())
                Spacer()
            }
            
            HStack {
                Spacer()
                Text("H:").foregroundColor(.secondary)
                Text(price.high.formatPriceNumber())
                
                Text("L:").foregroundColor(.secondary)
                Text(price.low.formatPriceNumber())
                Spacer()
            }
        }
        .lineLimit(1)
        .font(.footnote)
        .padding(.vertical)
    }
}
