//
//  CardView.swift
//  Set
//
//  Created by Arpit Gogia on 29/05/18.
//  Copyright © 2018 Arpit Gogia. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    var shape: String = "pill" {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }

    var count: Int = 3 {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }

    var fillStyle: String = "hollow" {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }

    var color: UIColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1) {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    var isSelected: Bool = false {
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
    
    private func drawPill(currentPath: UIBezierPath?, center: CGPoint) -> UIBezierPath {
        let path: UIBezierPath?
        if currentPath != nil {
            path = currentPath
        } else {
            path = UIBezierPath()
        }
        let start = center.applying(CGAffineTransform(translationX: CGFloat(-Constants.CardUI.pillSideLength/2), y: CGFloat(-Constants.CardUI.radius)))
        path?.move(to: start)
        path?.addLine(to: (path?.currentPoint.applying(CGAffineTransform(translationX: CGFloat(Constants.CardUI.sideLength), y: 0)))!)
        path?.addArc(withCenter: (path?.currentPoint.applying(CGAffineTransform(translationX: 0, y: CGFloat(Constants.CardUI.radius))))!, radius: CGFloat(Constants.CardUI.radius), startAngle: 3 * CGFloat.pi / 2, endAngle: CGFloat.pi / 2, clockwise: true)
        path?.addLine(to: (path?.currentPoint.applying(CGAffineTransform(translationX: CGFloat(-Constants.CardUI.sideLength), y: 0)))!)
        path?.addArc(withCenter: (path?.currentPoint.applying(CGAffineTransform(translationX: 0, y: CGFloat(-Constants.CardUI.radius))))!, radius: CGFloat(Constants.CardUI.radius), startAngle: CGFloat.pi / 2, endAngle: 3 * CGFloat.pi / 2, clockwise: true)
        return path!
    }
    
    private func drawDiamond(currentPath: UIBezierPath?, center: CGPoint) -> UIBezierPath {
        let path: UIBezierPath?
        if currentPath != nil {
            path = currentPath
        } else {
            path = UIBezierPath()
        }
        let start = center.applying(CGAffineTransform(translationX: 0, y: CGFloat(-Constants.CardUI.semiMinorAxis)))
        path?.move(to: start)
        path?.addLine(to: (path?.currentPoint.applying(CGAffineTransform(translationX: CGFloat(Constants.CardUI.semiMajorAxis), y: CGFloat(Constants.CardUI.semiMinorAxis))))!)
        path?.addLine(to: (path?.currentPoint.applying(CGAffineTransform(translationX: CGFloat(-Constants.CardUI.semiMajorAxis), y: CGFloat(Constants.CardUI.semiMinorAxis))))!)
        path?.addLine(to: (path?.currentPoint.applying(CGAffineTransform(translationX: CGFloat(-Constants.CardUI.semiMajorAxis), y: CGFloat(-Constants.CardUI.semiMinorAxis))))!)
        path?.close()
        return path!
    }
    
    private func drawSquiggle(currentPath: UIBezierPath?, center: CGPoint) -> UIBezierPath {
        let path: UIBezierPath?
        if currentPath != nil {
            path = currentPath
        } else {
            path = UIBezierPath()
        }
        
        let start = center.applying(CGAffineTransform(translationX: CGFloat(-Constants.CardUI.semiMajorAxis), y: CGFloat(Constants.CardUI.semiMinorAxis)))
        path?.move(to: start)

        //Upper Half
        path?.addQuadCurve(to: center.applying(CGAffineTransform(translationX: 0, y: CGFloat(-Constants.CardUI.semiMinorAxis/2))), controlPoint: center.applying(CGAffineTransform(translationX: CGFloat(-Constants.CardUI.semiMajorAxis/2), y: CGFloat(-Constants.CardUI.semiMinorAxis))))
        
        path?.addQuadCurve(to: center.applying(CGAffineTransform(translationX: CGFloat(Constants.CardUI.semiMajorAxis), y: CGFloat(-Constants.CardUI.semiMinorAxis))), controlPoint: center.applying(CGAffineTransform(translationX: CGFloat(Constants.CardUI.semiMajorAxis/2), y: 0)))
        
        //Lower Half
        path?.addQuadCurve(to: center.applying(CGAffineTransform(translationX: 0, y: CGFloat(Constants.CardUI.semiMinorAxis/2))), controlPoint: center.applying(CGAffineTransform(translationX: CGFloat(Constants.CardUI.semiMajorAxis/2), y: CGFloat(Constants.CardUI.semiMinorAxis))))
        
        path?.addQuadCurve(to: center.applying(CGAffineTransform(translationX: CGFloat(-Constants.CardUI.semiMajorAxis), y: CGFloat(Constants.CardUI.semiMinorAxis))), controlPoint: center.applying(CGAffineTransform(translationX: CGFloat(-Constants.CardUI.semiMajorAxis/2), y: 0)))
        
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
    
    private func drawSymbols(parent: CGRect, shape: String, number: Int, fillStyle: String, color: UIColor) {
        var shapeDrawer: (UIBezierPath?, CGPoint) -> UIBezierPath?
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
        
        
        var startPoint = CGPoint()
        
        switch number {
        case Card.Number.one.rawValue:
            startPoint = CGPoint(x: parent.midX, y: parent.midY)
        case Card.Number.two.rawValue:
            startPoint = CGPoint(x: parent.midX, y: parent.midY - CGFloat(Constants.CardUI.symbolGap))
        case Card.Number.three.rawValue:
            startPoint = CGPoint(x: parent.midX, y: parent.midY - CGFloat(Constants.CardUI.majorAxis - Constants.CardUI.symbolGap))
        default:
            startPoint = CGPoint(x: parent.midX, y: parent.midY)
        }
        
        var path = UIBezierPath()
        for _ in 1...number {
            path = shapeDrawer(path, startPoint)!
            startPoint = startPoint.applying(CGAffineTransform(translationX: 0, y: CGFloat(Constants.CardUI.symbolGap + Constants.CardUI.minorAxis)))
        }
        if fillStyle == Card.Fill.shaded.rawValue {
            path.addClip()
        }
        setProperties(path: &path, fillStyle: fillStyle, color: color)
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
        
        drawSymbols(parent: roundedRect.bounds, shape: shape, number: count, fillStyle: fillStyle, color: color)
    }
}
