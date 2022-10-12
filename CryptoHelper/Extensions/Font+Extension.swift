//
//  EventFonts.swift
//  CryptoHelper
//
//  Created by Alexandru Jdanov on 05.09.2022.
//

import SwiftUI

extension Font {
    struct Event {
        let name = Font.system(size: 14, weight: .regular, design: .default)
        let code = Font.system(size: 14, weight: .regular, design: .default)
        let price = Font.custom("Trebuchet MS", size: 14)
        let minMaxPriceLabel = Font.custom("Trebuchet MS", size: 8)
        let minMaxPrice = Font.custom("Trebuchet MS", size: 9)
    }
    
    static let event = Event()
}
