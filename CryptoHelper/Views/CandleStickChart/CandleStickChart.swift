//
//  CandleStickChart.swift
//  CryptoHelper
//
//  Created by Alexandru Jdanov on 21.09.2022.
//

import SwiftUI
import Charts

struct CandleStickChart: View {
    @StateObject var viewModel: StockPricesViewModel
    
    var body: some View {
        List {
            Section {
                if viewModel.coin.stockPrices.isEmpty {
                    Text("Please wait while data is being collected.")
                        .listRowSeparator(.hidden)
                }
                
                chart
            }
            Section {
                Text("**Hold and drag** over the chart to view and move the lollipop.")
                    .font(.callout)
            }
        }
        .navigationTitle(viewModel.coin.name)
    }
    
    private var chart: some View {
        Chart(viewModel.coin.stockPrices) { (price: StockPrice) in
            CandleStickMark(
                timestamp: .value("Date", price.timestamp),
                openValue: .value("Open", price.open),
                highValue: .value("High", price.high),
                lowValue: .value("Low", price.low),
                closeValue: .value("Close", price.close)
            )
            .foregroundStyle(price.open < price.close ? Color("customGreen") : Color("customRed"))
        }
        .chartYScale(domain: viewModel.yValues)
        .chartXScale(domain: viewModel.xValues)
        
        .chartYAxis {
            AxisMarks { value in
                AxisGridLine(centered: true, stroke: StrokeStyle(dash: [1, 2]))
                AxisTick(centered: true, stroke: StrokeStyle(dash: [1, 2]))
                AxisValueLabel() {
                    if let value = value.as(Double.self) {
                        Text(value.formatPriceNumber())
                    }
                }
            }
        }
        
        .chartOverlay { proxy in
            GeometryReader { geo in
                Rectangle().fill(.clear).contentShape(Rectangle())
                    .gesture(
                        SpatialTapGesture()
                            .onEnded { value in
                                viewModel.chooseValue(proxy: proxy, geo: geo, value: value)
                                viewModel.calculatePriceBoxOffset(proxy: proxy, geo: geo)
                            }
                            .exclusively(
                                before: DragGesture()
                                    .onChanged { value in
                                        viewModel.changeDragValue(proxy: proxy, geo: geo, value: value)
                                        viewModel.calculatePriceBoxOffset(proxy: proxy, geo: geo)
                                    }
                            )
                    )
            }
            ZStack(alignment: .topLeading) {
                if let selectedPrice = viewModel.selectedPrice {
                    Rectangle()
                        .fill(.gray.opacity(0.5))
                        .frame(width: 2, height: viewModel.lineHeight)
                        .position(x: viewModel.lineX, y: viewModel.lineHeight / 2)
                    
                    PriceAnnotation(for: selectedPrice)
                        .frame(width: 220, alignment: .leading)
                        .background {
                            RoundedRectangle(cornerRadius: 13)
                                .foregroundStyle(.thickMaterial)
                                .padding(.horizontal, -8)
                                .padding(.vertical, -4)
                        }
                        .offset(x: viewModel.boxOffset)
                }
            }
        }
        .frame(height: 300)
    }
}

struct CandleStickChart_Previews: PreviewProvider {
    static var previews: some View {
        CandleStickChart(viewModel: StockPricesViewModel(Coin()))
    }
}
