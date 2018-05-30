//
//  Card.swift
//  Set
//
//  Created by Arpit Gogia on 24/05/18.
//  Copyright © 2018 Arpit Gogia. All rights reserved.
//

import Foundation
import UIKit
import EnumCollection

struct Card: Hashable {
    var shape: Shape
    var fill: Fill
    var color: Color
    var number: Number
    
    enum Shape: String, EnumCollection {
        case diamond = "diamond"
        case squiggle = "squiggle"
        case pill = "pill"
    }
    
    enum Fill: String, EnumCollection {
        case solid = "solid"
        case shaded = "stripe"
        case hollow = "blank"
        
        var fill: CGFloat {
            switch self {
            case .solid: return 0
            case .shaded: return 1
            case .hollow: return 5
            }
        }
    }
    
    enum Color: EnumCollection {
        case purple
        case red
        case green
        
        var color: UIColor {
            switch self {
            case .purple: return #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
            case .red: return #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            case .green: return #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            }
        }
    }
    
    enum Number: Int, EnumCollection {
        case one = 1, two, three
    }
    
    init(color: Color, shape: Shape, fill: Fill, number: Number) {
        self.color = color
        self.shape = shape
        self.fill = fill
        self.number = number
    }
}

extension Card {
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return (lhs.color == rhs.color) &&
            (lhs.shape == rhs.shape) &&
            (lhs.fill == rhs.fill) &&
            (lhs.number == rhs.number)
    }
}
