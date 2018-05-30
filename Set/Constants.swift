//
//  GameConstants.swift
//  Set
//
//  Created by Arpit Gogia on 25/05/18.
//  Copyright © 2018 Arpit Gogia. All rights reserved.
//

import Foundation

struct Constants {
    private init() {}
    
    struct Game {
        static let maxNumberOfCardsOnBoard = 24
        static let cardsToBeDealt = 3
        static let initialNumberOfCards = 12
        static let numberOfCardsInSet = 3
        static let successfulSetScore = 1
        static let failedSetScore = -1
        static let buttonCornerRadius = 4.0
    }
    
    struct CardUI {
        static let sideLength: Float = 50.0
        static let radius: Float = 25.0
        static let pillSideLength: Float = 50.0
        static let arcRadius: Float = 25.0
        static let stripeGap: Float = 5.0
        
        static let majorAxis: Float = 100.0
        static let minorAxis: Float = 50.0
        
        static var semiMajorAxis: Float {
            return majorAxis / 2.0
        }
        
        static var semiMinorAxis: Float {
            return minorAxis / 2.0
        }
        
        static let symbolGap: Float = 20.0
    }
}
