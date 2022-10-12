//
//  ContentView.swift
//  CryptoHelper
//
//  Created by Alexandru Jdanov on 03.09.2022.
//

import SwiftUI
import RealmSwift

struct CoinListView: View {
    @StateObject var viewModel = CoinsViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                List() {
                    ForEach(viewModel.coins) { coin in
                        CoinRowView(coin: coin)
                    }
                }
                .listStyle(.plain)
                .onAppear {
                    viewModel.addFirstCoins()
                    UITableView.appearance().showsVerticalScrollIndicator = false
                }
                .onReceive(viewModel.timer, perform: { _ in
                    viewModel.connectToCryptoAPI()
                })
            }
            .navigationTitle("Market")
            .clipShape(Rectangle())
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication
            .didBecomeActiveNotification), perform: { _ in
                viewModel.clearStockPricesHistory()
            })
    }
}

struct CoinListView_Previews: PreviewProvider {
    static var previews: some View {
        CoinListView()
    }
}
