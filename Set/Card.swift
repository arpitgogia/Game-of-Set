//
//  Card.swift
//  Set
//
//  Created by Arpit Gogia on 24/05/18.
//  Copyright © 2018 Arpit Gogia. All rights reserved.
//

import Foundation
import UIKit


struct Card {
    var shape: Shape
    var fill: Fill
    var color: Color
    var number: Number
    
    enum Shape: String {
        case circle = "●"
        case triangle = "▲"
        case square = "■"
        static let all = [circle, triangle, square]
    }
    
    enum Fill: String {
        case solid = "solid"
        case shaded = "stripe"
        case hollow = "blank"
        static let all = [solid, shaded, hollow]
    }
    
    enum Color: String {
        case purple = "purple"
        case red = "red"
        case green = "green"
        static let all = [purple, red, green]
    }
    
    enum Number: Int {
        case one = 1, two, three
        static let all = [one, two, three]
    }
    
    init(withColor color: Color, withShape shape: Shape, withFill fill: Fill, withNumber number: Number) {
        self.color = color
        self.shape = shape
        self.fill = fill
        self.number = number
    }
}

extension Card: Equatable {
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return (lhs.color == rhs.color) &&
            (lhs.shape == rhs.shape) &&
            (lhs.fill == rhs.fill) &&
            (lhs.number == rhs.number)
    }
}
