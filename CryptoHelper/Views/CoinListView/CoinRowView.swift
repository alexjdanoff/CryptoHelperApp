//
//  CoinRow.swift
//  CryptoHelper
//
//  Created by Alexandru Jdanov on 10.09.2022.
//

import SwiftUI
import RealmSwift

struct CoinRowView: View {
    @ObservedRealmObject var coin: Coin
    
    var body: some View {
        VStack {
            HStack {
                AsyncImage(url: URL(string: coin.imageUrl),
                           scale: 10)
                Text(coin.name)
                    .font(Font.event.name)
                    .frame(height: 40)
                Text(coin.code)
                    .font(Font.event.code)
                    .foregroundColor(Color.gray)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(coin.priceMovement.color)
                        .frame(width: 85, height: 30)
                        .overlay(Text(coin.prices.last?.formatPriceNumber() ?? ""))
                        .font(Font.event.price)
                        .foregroundColor(coin.priceMovement.textColor)
                        .padding(EdgeInsets(top: 0,
                                            leading: 0,
                                            bottom: 0,
                                            trailing: -20))
                }
                .padding(EdgeInsets(top: 0,
                                    leading: 0,
                                    bottom: 0,
                                    trailing: 20))
            }
            HStack(spacing: 30) {
                HStack(spacing: 1) {
                    Text("min:")
                        .font(Font.event.minMaxPriceLabel)
                        .foregroundColor(Color.gray)
                    
                    Text(String(coin.prices.min()?.formatPriceNumber() ?? ""))
                        .font(Font.event.minMaxPrice)
                        .foregroundColor(Color("customBlack"))
                }
                .padding(EdgeInsets(top: 0,
                                    leading: 40,
                                    bottom: 0,
                                    trailing: 0))
                HStack(spacing: 1) {
                    Text("max:")
                        .font(Font.event.minMaxPriceLabel)
                        .foregroundColor(Color.gray)
                    
                    Text(String(coin.prices.max()?.formatPriceNumber() ?? ""))
                        .font(Font.event.minMaxPrice)
                        .foregroundColor(Color("customBlack"))
                }
                Spacer()
            }
            .background(NavigationLink(destination: CandleStickChart(viewModel: StockPricesViewModel(coin))) { }
                    .opacity(0))
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct CoinListRow_Previews: PreviewProvider {
    static var previews: some View {
        CoinRowView(coin: Coin())
    }
}
