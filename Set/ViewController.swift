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
    private var selectedButtons = [UIButton]()
    private var hintButtons = [UIButton]()
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
    
    @IBAction func deal3Button(_ sender: UIButton) {
        if (game.cardsOnTable.count + Constants.Game.cardsToBeDealt <= Constants.Game.maxNumberOfCardsOnBoard) {
            game.dealMore(Constants.Game.cardsToBeDealt)
        } else if (Constants.Game.maxNumberOfCardsOnBoard - game.cardsOnTable.count > 0) {
            game.dealMore(Constants.Game.maxNumberOfCardsOnBoard - game.cardsOnTable.count)
        }
        //        updateViewFromModel()
    }
    
    @IBAction func newGameButton(_ sender: Any) {
        game = GameSet()
        selectedButtons = [UIButton]()
        replaceableButtonIndices = [Int]()
        scoreLabel.text = "Score: \(0)"
        //        updateViewFromModel()
        //        hideExtraCards()
    }
    
    @IBAction func hintButton(_ sender: UIButton) {
        let setFound = game.findSet()
        if setFound {
//            updateHintButtons()
        }
    }

    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        updateViewFromModel()
//    }
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
        let cardView = CardView(frame: gridRect.insetBy(dx: CGFloat(gridRect.size.width/15), dy: CGFloat(gridRect.size.height/15)))
        cardView.color = card.color.color
        cardView.count = card.number.rawValue
        cardView.fillStyle = card.fill.rawValue
        cardView.shape = card.shape.rawValue
        
        cardGridView.addSubview(cardView)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapCard))
        tapGestureRecognizer.delegate = self as UIGestureRecognizerDelegate
        cardView.addGestureRecognizer(tapGestureRecognizer)
        cardViews.append(cardView)
    }
    
    @objc private func tapCard(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            let location = sender.location(in: cardGridView)
            print(location)
            for (index, card) in cardViews.enumerated() {
                if card.bounds.contains(location) {
                    print(index)
                }
            }
        default:
            print("Shit!")
        }
    }
    
    @objc private func dealMore() {
        
    }
    
    @objc private func shuffle() {
        
    }
    
    private func updateViewFromModel() {
        grid = newGrid()
        cardGridView.subviews.forEach({$0.removeFromSuperview()})
        for (index, card) in game.cardsOnTable.enumerated() {
            setCard(card: card, indexOf: index)
        }
    }
}
