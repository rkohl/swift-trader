//
//  SwiftTraderOperation.swift
//  
//
//  Created by Fernando Fernandes on 06.02.22.
//

import Foundation

/// The currently running `SwiftTrader` operation.
public enum SwiftTraderOperation {
    case ftxPositions
    case kucoinFuturesAccountOverview
    case kucoinFuturesCancelStopOrders
    case kucoinFuturesOrderList
    case kucoinFuturesStopOrderList
    case kucoinFuturesPlaceStopLimitOrder
    case kucoinFuturesPositionList
}
