//
//  ViewController.swift
//  Set
//
//  Created by Arpit Gogia on 24/05/18.
//  Copyright © 2018 Arpit Gogia. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    private var game = GameSet()
    private var selectedCardViews = [CardView]()
    private var hintCardViews = [CardView]()
    private var replaceableButtonIndices = [Int]()
    private lazy var grid = newGrid()
    private var cardViews = [CardView]()
    
    @IBOutlet weak var dealButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet weak var cardGridView: UIView! {
        didSet {
            let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(dealMore))
            swipeGestureRecognizer.direction = .down
            cardGridView.addGestureRecognizer(swipeGestureRecognizer)
            
            let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(shuffle))
            cardGridView.addGestureRecognizer(rotationGestureRecognizer)
        }
    }
    
    @IBAction func dealButton(_ sender: UIButton) {
        dealMore()
    }
    
    @IBAction func newGameButton(_ sender: Any) {
        game = GameSet()
        selectedCardViews = [CardView]()
        replaceableButtonIndices = [Int]()
        scoreLabel.text = "Score: \(0)"
        updateViewFromModel()
    }
    
    @IBAction func hintButton(_ sender: UIButton) {
        selectedCardViews.removeAll()
        let setFound = game.findSet()
        updateViewFromModel()
        if setFound {
            for card in game.hintSet {
                let hintIndex = game.cardsOnTable.index(of: card)!
                cardViews[hintIndex].hint()
                hintCardViews.append(cardViews[hintIndex])
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func newGrid() -> Grid {
        let gridSideCount = Int(ceil(sqrt(Double(game.cardsOnTable.count))))
        return Grid(layout: Grid.Layout.dimensions(rowCount: gridSideCount, columnCount: gridSideCount), frame: cardGridView.bounds.insetBy(dx: CGFloat(Constants.GridUI.gridInsetMeasure), dy: CGFloat(Constants.GridUI.gridInsetMeasure)))
    }
    
    private func setCard(card: Card, indexOf subView: Int) {
        let gridRect = grid[subView]!
        let cardView = CardView(frame: gridRect.insetBy(dx: 4, dy: 4), card: card)
        
        cardGridView.addSubview(cardView)
        cardView.addTarget(self, action:  #selector(tapCard), for: .touchUpInside)
        cardViews.append(cardView)
    }
    
    private func getCardIndex(_ cardView: CardView) -> Int {
        for (index, card) in cardViews.enumerated() {
            
            if card.isEqual(cardView) {
                return index
            }
        }

        fatalError()
    }
    
    private func selectCard(_ index: Int) {
        let cardView = cardViews[index]
        
        let scoreOfMove = game.chooseCard(at: index)
        
        if hintCardViews.count == Constants.Game.numberOfCardsInSet {
            for card in hintCardViews {
                card.dehint()
            }
            hintCardViews.removeAll()
        }
        
        if selectedCardViews.contains(cardView) {
            cardView.deselect()
            selectedCardViews.remove(at: selectedCardViews.index(of: cardView)!)
            return
        }
        
        selectedCardViews.append(cardView)
        cardView.select()
        
        
        if selectedCardViews.count == Constants.Game.numberOfCardsInSet {
            if scoreOfMove == Constants.Game.successfulSetScore {
                for card in selectedCardViews {
                    cardViews.remove(at: cardViews.index(of: card)!)
                }
                updateViewFromModel()
            } else {
                for card in selectedCardViews {
                    card.deselect()
                }
            }
            selectedCardViews.removeAll()
        }
    }
    
    @objc private func tapCard(_ sender: CardView) {
        selectCard(getCardIndex(sender))
    }
    
    private func disableDeal() {
        dealButton.isEnabled = false
        dealButton.alpha = 0.2
    }
    
    private func enableDeal() {
        dealButton.isEnabled = true
        dealButton.alpha = 1.0
    }
    
    @objc private func dealMore() {
        if game.cardDeck.count > 0 {
            game.dealMore(min(abs(game.cardDeck.count - game.cardsOnTable.count), Constants.Game.cardsToBeDealt))
            updateViewFromModel()
        } else {
            disableDeal()
        }
    }
    
    @objc private func shuffle(_ sender: UIRotationGestureRecognizer) {
        switch sender.state {
        case .ended:
            game.shuffle()
            updateViewFromModel()
        default:
            break
        }
    }
    
    private func updateViewFromModel() {
        grid = newGrid()
        cardGridView.subviews.forEach({ $0.removeFromSuperview() })
        cardViews = [CardView]()
        for (index, card) in game.cardsOnTable.enumerated() {
            setCard(card: card, indexOf: index)
        }
        if game.cardDeck.count == 0 {
            disableDeal()
        } else {
            enableDeal()
        }
        scoreLabel.text = "Score: \(game.score)"
    }
}
