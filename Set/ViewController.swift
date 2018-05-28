//
//  ViewController.swift
//  Set
//
//  Created by Arpit Gogia on 24/05/18.
//  Copyright © 2018 Arpit Gogia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var game = Set()
    private var selectedButtons = [UIButton]()
    private var replaceableButtonIndices = [Int]()
    
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet weak var deal3ButtonOutlet: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func deal3Button(_ sender: UIButton) {
        if (game.cardsOnTable.count + GameConstant.cardsToBeDealt <= 24) {
            game.dealMore(3)
        } else if (24 - game.cardsOnTable.count > 0) {
            game.dealMore(24 - game.cardsOnTable.count)
        }
        updateViewFromModel()
    }
    
    @IBAction func newGameButton(_ sender: Any) {
        game = Set()
        selectedButtons = [UIButton]()
        replaceableButtonIndices = [Int]()
        scoreLabel.text = "Score: \(0)"
        updateViewFromModel()
        hideExtraCards()
    }
    
    @IBAction func touchButton(_ sender: UIButton) {
        let buttonIndex = cardButtons.index(of: sender)!
        let scoreOfMove = game.chooseCard(at: buttonIndex)
        selectButton(sender, scoreOfMove: scoreOfMove)
        if selectedButtons.count == 0 && scoreOfMove == 1 {
            updateViewFromModel()
        }
        scoreLabel.text = "Score: \(game.score)"
    }
    
    private func hideExtraCards() {
        if game.cardsOnTable.count == 12 {
            for index in 12..<24 {
                cardButtons[index].backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)
                cardButtons[index].setAttributedTitle(NSAttributedString(string: ""), for: UIControlState.normal)
            }
        }
    }
    
    private func selectButton(_ button: UIButton, scoreOfMove: Int) {
        if selectedButtons.contains(button) {
            button.layer.borderWidth = 0.0
            selectedButtons.remove(at: selectedButtons.index(of: button)!)
            return
        }
        selectedButtons.append(button)
        if selectedButtons.count == 3 {
            if scoreOfMove == 1 {
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
        } else if selectedButtons.count < 3 {
            button.layer.borderWidth = 3.0
            button.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
    }

    private func getAttributedTitle(for card: Card) -> NSAttributedString {
        var fill: CGFloat, alpha: CGFloat
        var textToWrite = card.shape.rawValue
        switch card.fill {
        case .solid:
            fill = 0
            alpha = 1.0
        case .shaded:
            fill = -1
            alpha = 0.2
        case .hollow:
            fill = 5
            alpha = 1.0
        }
        
        switch card.number {
        case .two: textToWrite += " \(textToWrite)"
        case .three: textToWrite += " \(textToWrite) \(textToWrite)"
        default: break
        }
        
        let color = card.color.color
        let attributes: [NSAttributedStringKey: Any] = [
            .strokeColor: color,
            .strokeWidth: fill,
            .foregroundColor: color.withAlphaComponent(alpha)
        ]
        return NSAttributedString(string: textToWrite, attributes: attributes)
    }
    
    func updateViewFromModel() {
        for index in game.cardsOnTable.indices {
            cardButtons[index].setAttributedTitle(getAttributedTitle(for: game.cardsOnTable[index]), for: .normal)
            cardButtons[index].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        if game.cardDeck.count <= 0 {
            deal3ButtonOutlet.isEnabled = false
            deal3ButtonOutlet.alpha = 0.5
        }
    }
}
