//
//  CardView.swift
//  Set
//
//  Created by Arpit Gogia on 29/05/18.
//  Copyright © 2018 Arpit Gogia. All rights reserved.
//

import UIKit

class CardView: UIControl {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, card: Card) {
        self.init(frame: frame)
        self.shape = card.shape.rawValue
        self.count = card.number.rawValue
        self.fillStyle = card.fill.rawValue
        self.color = card.color.color
        
        setNeedsLayout()
        setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var shape: String!
    private var count: Int!
    private var fillStyle: String!
    private var color: UIColor!
    
    override var isSelected: Bool {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    var isHinted: Bool = false {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    private func drawPill(parent: CGRect, currentPath: UIBezierPath?, center: CGPoint) -> UIBezierPath {
        let pillSideLength = parent.size.width / 3
        let radius = parent.size.height / 8
        let path: UIBezierPath?
        if currentPath != nil {
            path = currentPath
        } else {
            path = UIBezierPath()
        }
        
        let start = center.applying(CGAffineTransform(translationX: CGFloat(-pillSideLength/2), y: CGFloat(-radius)))
        path?.move(to: start)
        path?.addLine(to: (path?.currentPoint.applying(CGAffineTransform(translationX: CGFloat(pillSideLength), y: 0)))!)
        path?.addArc(withCenter: (path?.currentPoint.applying(CGAffineTransform(translationX: 0, y: CGFloat(radius))))!, radius: CGFloat(radius), startAngle: 3 * CGFloat.pi / 2, endAngle: CGFloat.pi / 2, clockwise: true)
        path?.addLine(to: (path?.currentPoint.applying(CGAffineTransform(translationX: CGFloat(-pillSideLength), y: 0)))!)
        path?.addArc(withCenter: (path?.currentPoint.applying(CGAffineTransform(translationX: 0, y: CGFloat(-radius))))!, radius: CGFloat(radius), startAngle: CGFloat.pi / 2, endAngle: 3 * CGFloat.pi / 2, clockwise: true)
        return path!
    }
    
    private func drawDiamond(parent: CGRect, currentPath: UIBezierPath?, center: CGPoint) -> UIBezierPath {
        let semiMajorAxis = parent.size.width / 3
        let semiMinorAxis = parent.size.height / 8
        let path: UIBezierPath?
        if currentPath != nil {
            path = currentPath
        } else {
            path = UIBezierPath()
        }
        let start = center.applying(CGAffineTransform(translationX: 0, y: CGFloat(-semiMinorAxis)))
        path?.move(to: start)
        path?.addLine(to: (path?.currentPoint.applying(CGAffineTransform(translationX: CGFloat(semiMajorAxis), y: CGFloat(semiMinorAxis))))!)
        path?.addLine(to: (path?.currentPoint.applying(CGAffineTransform(translationX: CGFloat(-semiMajorAxis), y: CGFloat(semiMinorAxis))))!)
        path?.addLine(to: (path?.currentPoint.applying(CGAffineTransform(translationX: CGFloat(-semiMajorAxis), y: CGFloat(-semiMinorAxis))))!)
        path?.close()
        return path!
    }
    
    private func drawSquiggle(parent: CGRect, currentPath: UIBezierPath?, center: CGPoint) -> UIBezierPath {
        let semiMajorAxis = parent.size.width / 3
        let semiMinorAxis = parent.size.height / 8
        let path: UIBezierPath?
        if currentPath != nil {
            path = currentPath
        } else {
            path = UIBezierPath()
        }
        
        let start = center.applying(CGAffineTransform(translationX: CGFloat(-semiMajorAxis), y: CGFloat(semiMinorAxis)))
        path?.move(to: start)

        //Upper Half
        path?.addQuadCurve(to: center.applying(CGAffineTransform(translationX: 0, y: CGFloat(-semiMinorAxis/2))), controlPoint: center.applying(CGAffineTransform(translationX: CGFloat(-semiMajorAxis/2), y: CGFloat(-semiMinorAxis))))
        
        path?.addQuadCurve(to: center.applying(CGAffineTransform(translationX: CGFloat(semiMajorAxis), y: CGFloat(-semiMinorAxis))), controlPoint: center.applying(CGAffineTransform(translationX: CGFloat(semiMajorAxis/2), y: 0)))
        
        //Lower Half
        path?.addQuadCurve(to: center.applying(CGAffineTransform(translationX: 0, y: CGFloat(semiMinorAxis/2))), controlPoint: center.applying(CGAffineTransform(translationX: CGFloat(semiMajorAxis/2), y: CGFloat(semiMinorAxis))))
        
        path?.addQuadCurve(to: center.applying(CGAffineTransform(translationX: CGFloat(-semiMajorAxis), y: CGFloat(semiMinorAxis))), controlPoint: center.applying(CGAffineTransform(translationX: CGFloat(-semiMajorAxis/2), y: 0)))
        
        return path!
    }
    
    private func drawStripes(path: UIBezierPath, color: UIColor) -> UIBezierPath {
        let pathBounds = path.bounds
        var startOfLine = pathBounds.origin.applying(CGAffineTransform(translationX: CGFloat(Constants.CardUI.stripeGap), y: 0))
        while path.bounds.contains(startOfLine) {
            path.move(to: startOfLine)
            path.addLine(to: startOfLine.applying(CGAffineTransform(translationX: 0, y: pathBounds.size.height)))
            startOfLine = startOfLine.applying(CGAffineTransform(translationX: CGFloat(Constants.CardUI.stripeGap), y: 0))
        }
        
        return path
    }
    
    private func setProperties(path: inout UIBezierPath, fillStyle: String, color: UIColor) {
        if fillStyle == Card.Fill.solid.rawValue {
            color.setFill()
            path.fill()
        } else if fillStyle == Card.Fill.shaded.rawValue {
            path = drawStripes(path: path, color: color)
        }
        color.setStroke()
        path.stroke()
        path.apply(CGAffineTransform(scaleX: 0.2, y: 0.2))
    }
    
    func select() {
        isSelected = true
    }
    
    func deselect() {
        isSelected = false
    }
    
    func hint() {
        isHinted = true
    }

    // For the lack of a better word, lol
    func dehint() {
        isHinted = false
    }
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 4.0)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        
        if isSelected {
            UIColor.red.setStroke()
            roundedRect.lineWidth = 5.0
            roundedRect.stroke()
        }
        
        if isHinted {
            UIColor.green.setStroke()
            roundedRect.lineWidth = 5.0
            roundedRect.stroke()
        }
        
        drawSymbols(parent: bounds, shape: shape, number: count, fillStyle: fillStyle, color: color)
        
    }
    
    // Helpers
    
    
    private func drawSymbols(parent: CGRect, shape: String, number: Int, fillStyle: String, color: UIColor) {
        let symbolGap: Float = 1.0
        let translationDistance: Float = Float(parent.width / 2.0)
        
        
        var shapeDrawer: (CGRect, UIBezierPath?, CGPoint) -> UIBezierPath?
        switch shape {
        case Card.Shape.diamond.rawValue:
            shapeDrawer = drawDiamond
        case Card.Shape.pill.rawValue:
            shapeDrawer = drawPill
        case Card.Shape.squiggle.rawValue:
            shapeDrawer = drawSquiggle
        default:
            shapeDrawer = drawDiamond
        }
        
        
        var startingCenter = CGPoint()
        
        switch number {
        case Card.Number.one.rawValue:
            startingCenter = CGPoint(x: parent.midX, y: parent.midY)
        case Card.Number.two.rawValue:
            startingCenter = CGPoint(x: parent.midX, y: parent.midY - CGFloat(translationDistance - symbolGap))
        case Card.Number.three.rawValue:
            startingCenter = CGPoint(x: parent.midX, y: parent.midY - CGFloat(translationDistance - symbolGap))
        default:
            startingCenter = CGPoint(x: parent.midX, y: parent.midY)
        }
        
        var path = UIBezierPath()
        for _ in 1...number {
            path = shapeDrawer(parent, path, startingCenter)!
            var yTranslation = CGFloat(symbolGap + Float(parent.width/2))
            yTranslation = number == Card.Number.two.rawValue ? 2 * yTranslation : yTranslation
            startingCenter = startingCenter.applying(CGAffineTransform(translationX: 0, y: yTranslation))
        }
        if fillStyle == Card.Fill.shaded.rawValue {
            path.addClip()
        }
        setProperties(path: &path, fillStyle: fillStyle, color: color)
    }
}
