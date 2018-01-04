//
//  Arrow.swift
//  Seven Bridges
//
//  Created by Rob Mayoff, obtained from GitHub.
//  Updated to Swift 4 and modified by Dillon Fagan.
//  https://gist.github.com/mayoff/4146780
//

import UIKit

extension UIBezierPath {
    
    class func arrow(from start: CGPoint, to end: CGPoint, tailWidth: CGFloat, headWidth: CGFloat, headLength: CGFloat) -> Self {
        let length = hypot(end.x - start.x, end.y - start.y)
        let tailLength = length - headLength
        
        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { return CGPoint(x: x, y: y) }
        let points: [CGPoint] = [
            p(0, tailWidth / 2),
            p(tailLength, tailWidth / 2),
            //p(tailLength, headWidth / 2),
            p(length, 0),
            //p(tailLength, -headWidth / 2),
            p(tailLength, -tailWidth / 2),
            p(0, -tailWidth / 2)
        ]
        
        let cosine = (end.x - start.x) / length
        let sine = (end.y - start.y) / length
        let transform = CGAffineTransform(a: cosine, b: sine, c: -sine, d: cosine, tx: start.x, ty: start.y)
        
        let path = CGMutablePath()
        path.addLines(between: points, transform: transform)
        
        path.move(to: points[2], transform: transform)
        path.addLine(to: p(tailLength, headWidth / 1.2), transform: transform)
        
        path.move(to: points[2], transform: transform)
        path.addLine(to: p(tailLength, -headWidth / 1.2), transform: transform)
        
        path.closeSubpath()
        
        return self.init(cgPath: path)
    }
    
}
