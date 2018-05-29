//
//  Set.swift
//  Set
//
//  Created by Arpit Gogia on 24/05/18.
//  Copyright © 2018 Arpit Gogia. All rights reserved.
//

import Foundation
import EnumCollection
import UIKit

extension Set where Element: EnumCollection  {
    func getProperty() -> Element {
        var presentElements = Set<Element>()
        
        for element in self {
            presentElements.insert(element)
        }
        
        if presentElements.count == 2 {
            return Set(Element.allValues).subtracting(presentElements).first!
        } else {
            return presentElements.first!
        }
    }
}

class GameSet {
    private(set) var cardDeck = [Card]()
    
    private(set) var cardsOnTable = [Card]()
    
    private(set) var score = 0
    
    private(set) var hintSet = [Card]()
    
    var selectedCards = [Card]()
    var replaceableCards = [Int]()
    
    private func draw() {
        for _ in 1...3 {
            if cardDeck.count > 0 {
                cardsOnTable += [cardDeck.getRandomElement()]
            }
        }
    }
    
    private func populateDeck() {
        for _ in 1...4 {
            draw()
        }
    }
    
    private func isSet(_ withCards: [Card]) -> Bool {
        return true
    }
    
    func dealMore(_ n: Int) {
        for _ in 1...n {
            if cardDeck.count > 0 {
                cardsOnTable += [cardDeck.getRandomElement()]
            }
        }
    }
    
    func getThirdCard(_ cards: [Card]) -> Card {
        let thirdColor = Set(cards.map({$0.color})).getProperty()
        let thirdNumber = Set(cards.map({$0.number})).getProperty()
        let thirdFill = Set(cards.map({$0.fill})).getProperty()
        let thirdShape = Set(cards.map({$0.shape})).getProperty()

        return Card(color: thirdColor, shape: thirdShape, fill: thirdFill, number: thirdNumber)
    }
    
    func findSet() -> Bool {
        var card3: Card!
        for card1 in cardsOnTable {
            for card2 in cardsOnTable {
                if card1 != card2 {
                    card3 = getThirdCard([card1, card2])
                    if cardsOnTable.contains(card3) {
                        hintSet = [card1, card2, card3] as! [Card]
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func chooseCard(at index: Int) -> Int {
        if selectedCards.contains(cardsOnTable[index]) {
            selectedCards.remove(at: selectedCards.index(of: cardsOnTable[index])!)
            return 0
        }
        
        selectedCards += [cardsOnTable[index]]
        
        if selectedCards.count == 3 {
            if GameSet.checkIsSet(forCards: selectedCards) {
                for card in selectedCards {
                    if cardDeck.count > 0 {
                        cardsOnTable[cardsOnTable.index(of: card)!] = cardDeck.getRandomElement()
                    }
                }
                selectedCards.removeAll()
                //                draw()
                score += 1
                return 1
            } else {
                selectedCards.removeAll()
                score -= 1
                return -1
            }
        }
        return 0
    }
    
    private func replaceCards() {
        if cardDeck.count > 0 {
            for index in replaceableCards {
                cardsOnTable[index] = cardDeck.getRandomElement()
            }
        }
    }
    
    static private func colorTest(card1: Card, card2: Card, card3: Card) -> Bool {
        if card1 == card2 {
            
        }
        
        if card1.color == card2.color && card2.color == card3.color {
            return true
        } else if card1.color != card2.color && card2.color != card3.color && card1.color != card3.color {
            return true
        }
        return false
    }
    
    static private func fillTest(card1: Card, card2: Card, card3: Card) -> Bool {
        if card1.fill == card2.fill && card2.fill == card3.fill {
            return true
        } else if card1.fill != card2.fill && card2.fill != card3.fill && card1.fill != card3.fill {
            return true
        }
        return false
    }
    
    static private func shapeTest(card1: Card, card2: Card, card3: Card) -> Bool {
        if card1.shape == card2.shape && card2.shape == card3.shape {
            return true
        } else if card1.shape != card2.shape && card2.shape != card3.shape && card1.shape != card3.shape {
            return true
        }
        return false
    }
    
    static private func numberTest(card1: Card, card2: Card, card3: Card) -> Bool {
        if card1.number == card2.number && card2.number == card3.number {
            return true
        } else if card1.number != card2.number && card2.number != card3.number && card1.number != card3.number {
            return true
        }
        return false
    }
    
    static func checkIsSet(forCards: [Card]) -> Bool {
        if colorTest(card1: forCards[0], card2: forCards[1], card3: forCards[2]) &&
            numberTest(card1: forCards[0], card2: forCards[1], card3: forCards[2]) &&
            shapeTest(card1: forCards[0], card2: forCards[1], card3: forCards[2]) &&
            fillTest(card1: forCards[0], card2: forCards[1], card3: forCards[2]) {
            return true
        }
        return false
    }
    
    init() {
        for color in Card.Color.allValues {
            for fill in Card.Fill.allValues {
                for number in Card.Number.allValues {
                    for shape in Card.Shape.allValues {
                        cardDeck += [(Card(color: color, shape: shape, fill: fill, number: number))]
                    }
                }
            }
        }
        populateDeck()
    }
}

extension Array {
    mutating func getRandomElement() -> Element {
        return remove(at: Int(arc4random_uniform(UInt32(count - 1))))
    }
}
