//
// Created by Ben Morrison on 11/2/18.
// Copyright (c) 2018 Benjamin C Morrison. All rights reserved.
//

import Foundation

/**
 Predefined animation times for radio buttons with a customizable time as well.
 */
public enum RadioButtonAnimationInterval: CustomStringConvertible {
    /// Instant (No animation)
    case none
    /// Interval time of 0.15
    case fast
    /// Interval time of 0.25
    case standard
    /// Interval time of 0.5
    case slow
    /// Custom `TimeInterval`
    case custom(TimeInterval)

    internal var value: TimeInterval {
        switch self {
            case .none:                 return 0.0
            case .fast:                 return 0.15
            case .standard:             return 0.25
            case .slow:                 return 0.5
            case .custom(let interval): return interval
        }
    }

    public var description: String {
        return "TimeInterval: \(value)"
    }
}
