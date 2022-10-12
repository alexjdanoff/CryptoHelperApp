//
//  StockPricesViewModel.swift
//  CryptoHelper
//
//  Created by Alexandru Jdanov on 07.10.2022.
//

import SwiftUI
import Charts
import RealmSwift

@MainActor final class StockPricesViewModel: ObservableObject {
    @ObservedRealmObject var coin: Coin
    @Published var selectedPrice: StockPrice?
    @Published var lineHeight: CGFloat = 0.0
    @Published var lineX: CGFloat = 0.0
    @Published var boxOffset: CGFloat = 0.0
    
    init(_ coin: Coin) {
        self.coin = coin
    }
    
    var yValues: ClosedRange<Double> {
        let minCoinPrice = coin.prices.min() ?? 0.0
        let maxCoinPrice = coin.prices.max() ?? 0.0
        
        return minCoinPrice...maxCoinPrice
    }
    
    var xValues: ClosedRange<Date> {
        if let minDate = coin.stockPrices.first?.timestamp,
           let maxDate = coin.stockPrices.last?.timestamp {
            return minDate...maxDate + Double((42 * 30) - (coin.stockPrices.count * 30))
        }
        return Date.now...Date.now
    }
    
    func findElement(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> StockPrice? {
        let relativeXPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
        if let date = proxy.value(atX: relativeXPosition) as Date? {
            var minDistance: TimeInterval = .infinity
            var index: Int? = nil
            for dataIndex in coin.stockPrices.indices {
                let salesDataDistance = coin.stockPrices[dataIndex].timestamp.distance(to: date)
                if abs(salesDataDistance) < minDistance {
                    minDistance = abs(salesDataDistance)
                    index = dataIndex
                }
            }
            
            if let index {
                return coin.stockPrices[index]
            }
        }
        
        return nil
    }
    
    func chooseValue(proxy: ChartProxy, geo: GeometryProxy, value: SpatialTapGesture.Value) {
        let element = findElement(location: value.location, proxy: proxy, geometry: geo)
        selectedPrice = selectedPrice?.timestamp == element?.timestamp ? nil : element
    }
    
    func changeDragValue(proxy: ChartProxy, geo: GeometryProxy, value: DragGesture.Value) {
        selectedPrice = findElement(location: value.location, proxy: proxy, geometry: geo)
    }
    
    func calculatePriceBoxOffset(proxy: ChartProxy, geo: GeometryProxy) {
        if let selectedPrice {
            let dateInterval = Calendar.current
                .dateInterval(of: .second, for: selectedPrice.timestamp)
            let startPositionX1 = proxy.position(forX: dateInterval?.start ?? Date.now) ?? 0
            let boxWidth: CGFloat = 220
            lineX = startPositionX1 + geo[proxy.plotAreaFrame].origin.x
            lineHeight = geo[proxy.plotAreaFrame].maxY
            boxOffset = max(0, min(geo.size.width - boxWidth, lineX - boxWidth / 2))
        }
    }
}
