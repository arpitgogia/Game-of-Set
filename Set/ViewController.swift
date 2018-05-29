//
//  ViewController.swift
//  Set
//
//  Created by Arpit Gogia on 24/05/18.
//  Copyright © 2018 Arpit Gogia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var game = GameSet()
    private var selectedButtons = [UIButton]()
    private var hintButtons = [UIButton]()
    private var replaceableButtonIndices = [Int]()
    
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet weak var dealButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var hintButton: UIButton!
    
    
    @IBAction func hintButton(_ sender: UIButton) {
        let setFound = game.findSet()
        if setFound {
            updateHintButtons()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCornerRadius()
        updateViewFromModel()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func deal3Button(_ sender: UIButton) {
        if (game.cardsOnTable.count + GameConstants.cardsToBeDealt <= GameConstants.maxNumberOfCardsOnBoard) {
            game.dealMore(GameConstants.cardsToBeDealt)
        } else if (GameConstants.maxNumberOfCardsOnBoard - game.cardsOnTable.count > 0) {
            game.dealMore(GameConstants.maxNumberOfCardsOnBoard - game.cardsOnTable.count)
        }
        updateViewFromModel()
    }
    
    @IBAction func newGameButton(_ sender: Any) {
        game = GameSet()
        selectedButtons = [UIButton]()
        replaceableButtonIndices = [Int]()
        scoreLabel.text = "Score: \(0)"
        updateViewFromModel()
        hideExtraCards()
    }
    
    @IBAction func touchButton(_ sender: UIButton) {
        let buttonIndex = cardButtons.index(of: sender)!
        if (buttonIndex > game.cardsOnTable.count - 1) {
            return
        }
        let scoreOfMove = game.chooseCard(at: buttonIndex)
        selectButton(sender, scoreOfMove: scoreOfMove)
        if selectedButtons.count == 0 && scoreOfMove == 1 {
            updateViewFromModel()
        }
        scoreLabel.text = "Score: \(game.score)"
    }
    
    private func hideExtraCards() {
        if game.cardsOnTable.count == GameConstants.initialNumberOfCards {
            for index in GameConstants.initialNumberOfCards..<GameConstants.maxNumberOfCardsOnBoard {
                cardButtons[index].backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)
                cardButtons[index].setAttributedTitle(NSAttributedString(string: ""), for: UIControlState.normal)
            }
        }
    }
    
    private func selectButton(_ button: UIButton, scoreOfMove: Int) {
        if hintButtons.contains(button) {
            clearHint()
        }
        if selectedButtons.contains(button) {
            button.layer.borderWidth = 0.0
            selectedButtons.remove(at: selectedButtons.index(of: button)!)
            return
        }
        selectedButtons.append(button)
        if selectedButtons.count == GameConstants.numberOfCardsInSet {
            if scoreOfMove == GameConstants.successfulSetScore {
                for card in selectedButtons {
                    card.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)
                    card.setAttributedTitle(NSAttributedString(string: ""), for: UIControlState.normal)
                    card.layer.borderWidth = 0
                }
            } else {
                for card in selectedButtons {
                    card.layer.borderWidth = 0.0
                }
            }
            selectedButtons.removeAll()
        } else if selectedButtons.count < GameConstants.numberOfCardsInSet {
            button.layer.borderWidth = 3.0
            button.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
    }

    private func getAttributedTitle(for card: Card) -> NSAttributedString {
        var alpha: CGFloat
        var textToWrite = card.shape.rawValue
        
        switch card.fill {
        case .solid:
            alpha = 1.0
        case .shaded:
            alpha = 0.2
        case .hollow:
            alpha = 1.0
        }
        
        switch card.number {
        case .two: textToWrite += " \(textToWrite)"
        case .three: textToWrite += " \(textToWrite) \(textToWrite)"
        default: break
        }
        
        let color = card.color.color
        let fill = card.fill.fill
        let attributes: [NSAttributedStringKey: Any] = [
            .strokeColor: color,
            .strokeWidth: fill,
            .foregroundColor: color.withAlphaComponent(alpha)
        ]
        return NSAttributedString(string: textToWrite, attributes: attributes)
    }
    
    func clearHint() {
        for index in game.cardsOnTable.indices {
            cardButtons[index].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
    
    func updateHintButtons() {
        if game.hintSet.count == 3 {
            for card in game.hintSet {
                let index = game.cardsOnTable.index(of: card)!
                hintButtons.append(cardButtons[index])
                cardButtons[index].backgroundColor = #colorLiteral(red: 1, green: 0.9848342538, blue: 0, alpha: 1)
            }
        }
    }
    
    func updateViewFromModel() {
        for index in game.cardsOnTable.indices {
            cardButtons[index].setAttributedTitle(getAttributedTitle(for: game.cardsOnTable[index]), for: .normal)
            cardButtons[index].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        if game.cardDeck.count <= 0 {
            dealButton.isEnabled = false
            dealButton.alpha = 0.5
        }
    }
    
    func addCornerRadius() {
        for button in cardButtons {
            button.layer.cornerRadius = CGFloat(GameConstants.buttonCornerRadius)
        }
        dealButton.layer.cornerRadius = CGFloat(GameConstants.buttonCornerRadius)
        newGameButton.layer.cornerRadius = CGFloat(GameConstants.buttonCornerRadius)
        hintButton.layer.cornerRadius = CGFloat(GameConstants.buttonCornerRadius)
    }
}
