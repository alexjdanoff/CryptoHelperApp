//
//  CryptoHelperApp.swift
//  CryptoHelper
//
//  Created by Alexandru Jdanov on 03.09.2022.
//

import SwiftUI

@main
struct CryptoHelperApp: App {
    var body: some Scene {
        WindowGroup {
            CoinListView()
                .onAppear {
                    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)
                    UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                }
        }
    }
}
