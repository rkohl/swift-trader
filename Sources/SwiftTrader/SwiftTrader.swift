//
//  SwiftTrader.swift
//
//
//  Created by Fernando Fernandes on 24.01.22.
//

import Foundation
import Logging

/// Entry point for connecting and trading on crypto exchanges such as Binance and Kucoin.
public struct SwiftTrader {
    
    // MARK: - Properties

    public let binanceAuth: BinanceAuth?
    public let ftxAuth: FTXAuth?
    public let kucoinAuth: KucoinAuth?
    public let logger = SwiftTraderLogger()
    public let settings: SwiftTraderSettings
    
    // MARK: - Lifecycle
    
    public init(binanceAuth: BinanceAuth,
                ftxAuth: FTXAuth? = nil,
                kucoinAuth: KucoinAuth?,
                settings: SwiftTraderSettings = DefaultSwiftTraderSettings()) {
        self.binanceAuth = binanceAuth
        self.ftxAuth = ftxAuth
        self.kucoinAuth = kucoinAuth
        self.settings = settings
    }
}
