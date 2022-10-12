//
//  CoinsViewModel.swift
//  CryptoHelper
//
//  Created by Alexandru Jdanov on 05.09.2022.
//

import CryptoAPI
import RealmSwift

final class CoinsViewModel: ObservableObject {
    @ObservedResults(Coin.self) var coins
    var timer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()
    private let databaseManager = DatabaseManager.shared
        
    private var cryptoAPI: Crypto {
        Crypto.init(delegate: self)
    }
    
    func connectToCryptoAPI() {
        let connectCrypto = cryptoAPI.connect()
        
        switch connectCrypto {
        case .success(let isSuccessful):
            if isSuccessful {
                print("Connection to the API service was successful")
            } else {
                print("Connection to API service failed")
            }
            
        case .failure(let error):
            print("Error connecting to the API service: \(error.localizedDescription)")
        }
    }
    
    func addFirstCoins() {
        guard coins.isEmpty else { return }
        let initialCoins = cryptoAPI.getAllCoins()
        
        initialCoins.forEach {
            let newCoin = Coin(name: $0.name,
                               price: $0.price,
                               code: $0.code,
                               imageUrl: $0.imageUrl ?? "",
                               priceMoviment: .stable)
            $coins.append(newCoin)
            self.objectWillChange.send()
        }
    }
    
    func updateCoins(_ newCoin: CryptoAPI.Coin) {
        let coinToUptade = coins.first { $0.name == newCoin.name }
        let lastCoinPrice = coinToUptade?.prices.last ?? 0.0
        
        databaseManager.modifyObject(block: {
            coinToUptade?.priceMovement = lastCoinPrice > newCoin.price ? .down : .up
            coinToUptade?.prices.append(newCoin.price)
            coinToUptade?.temporalPrices.append(newCoin.price)
        })
    }
    
    func removeOldCoinPrices(_ coin: Coin) {
        guard coin.prices.count > 100 else { return }
        for index in 0...coin.prices.count - 100 {
            databaseManager.modifyObject(block: {
                coin.prices.remove(at: index)
            })
        }
    }
        
    func addNewStockPrices(_ coin: Coin) {
        databaseManager.modifyObject(block: {
            if coin.temporalPrices.count > 1 {
                coin.stockPrices.append(StockPrice(open: coin.temporalPrices.first ?? 0.0,
                                                   high: coin.temporalPrices.max() ?? 0.0,
                                                   low: coin.temporalPrices.min() ?? 0.0,
                                                   close: coin.temporalPrices.last ?? 0.0))
            } else {
                if let lastStockPrice = coin.stockPrices.last {
                    coin.stockPrices.append(StockPrice(open: lastStockPrice.open,
                                                       high: lastStockPrice.high,
                                                       low: lastStockPrice.low,
                                                       close: lastStockPrice.close))
                }
            }
        })
    }
        
    func removeOldStockPrices(_ coin: Coin) {
        guard coin.stockPrices.count > 42 else { return }
        for index in 0...coin.stockPrices.count - 43 {
            databaseManager.deleteObject(object: coin.stockPrices[index])
        }
    }
    
    func updateStockPricesCount() {
        let allStockPrices = databaseManager.getObjects(type: StockPrice.self)
        let pricesStorageRate = coins.count * 43 * 2
        
        guard allStockPrices.count > pricesStorageRate else { return }
        
        for index in 0...allStockPrices.count - pricesStorageRate {
            databaseManager.deleteObject(object: allStockPrices[index])
        }
    }
    
    func clearStockPricesHistory() {
        coins.forEach { coin in
            databaseManager.modifyObject(block: {
                coin.stockPrices.removeAll()
                coin.priceMovement = .stable
            })
        }
    }
}

extension CoinsViewModel: CryptoDelegate {
    func cryptoAPIDidConnect() {
        Task {
            coins.forEach { coin in
                addNewStockPrices(coin)
                removeOldStockPrices(coin)
                databaseManager.modifyObject(block: {
                    coin.temporalPrices.removeAll()
                })
            }
        }
    }
    
    func cryptoAPIDidUpdateCoin(_ coin: CryptoAPI.Coin) {
        Task {
            updateCoins(coin)
        }
    }
    
    func cryptoAPIDidDisconnect() {
        Task {
            coins.forEach { coin in
                databaseManager.modifyObject(block: {
                    coin.priceMovement = .stable
                })
                removeOldCoinPrices(coin)
            }
            
            updateStockPricesCount()
        }
    }
}
