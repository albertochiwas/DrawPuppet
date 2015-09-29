//
//  ProcessingLib.swift
//  DibujaMarioneta
//
//  Created by Alberto Pacheco on 22/09/15.
//  Copyright © 2015 Alberto Pacheco. All rights reserved.
//

import Foundation
import UIKit
import Darwin


typealias Rect = (Int, Int, Int, Int)

extension UIColor
{
    convenience init(_ color: UInt32 ) {
        var alpha: CGFloat = CGFloat((color >> 24) & 0xFF)/255.0
        if alpha == 0.0 {
            alpha = 1.0
        }
        self.init(red: CGFloat((color >> 16) & 0xFF)/255.0, green: CGFloat((color >> 8) & 0xFF)/255.0, blue: CGFloat(color & 0xFF)/255.0, alpha: alpha )
    }
    convenience init(_ r: Int, _ g: Int, _ b: Int, _ a: Int = 255) {
        self.init(red: CGFloat(r % 256)/255.0, green: CGFloat(g % 256)/255.0, blue: CGFloat(b % 256)/255.0, alpha: CGFloat(a % 256)/255.0)
    }
    convenience init(_ v: Int, _ a: Int = 255) {
        self.init(red: CGFloat(v % 256)/255.0, green: CGFloat(v % 256)/255.0, blue: CGFloat(v % 256)/255.0, alpha: CGFloat(a % 256)/255.0)
    }
}


func map(value:Float, start1:Float, stop1:Float, start2:Float, stop2:Float) -> Float
{
    return start2 + (stop2 - start2) * ((value - start1) / (stop1 - start1))
}


func random( min: Int, max:Int ) -> Int
{
    return min + Int(arc4random_uniform(UInt32(max - min + 1)))
}


let PI_RADIANS = Float(180.0 * M_PI)

func radians( degrees: Float ) -> Float {
    return Float( degrees ) / PI_RADIANS
}

//typealias Punto = (Int , Int)

func line(x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat, width: CGFloat = 0) {
    line(CGPoint(x: x1,y: y1), end: CGPoint(x: x2, y: y2), width: width)
}

func line(start: CGPoint, end: CGPoint, width: CGFloat = 0) {
    let path = UIBezierPath()
//    path.lineCapStyle = kCGLineCapRound
    path.moveToPoint(start)
    path.addLineToPoint(end)
    if width > 0 {
        path.lineWidth = width
    }
    path.stroke()
}

// CASOS RECT: 1) STROKE ONLY; 2) FILL ONLY; 3) FILL & STROKE; +4) ROUND RECT?

func rectangle( rect: CGRect, width: CGFloat = 0, radius: CGFloat = 0 ) { // Stroke only
    let path = radius > 0 ?
        UIBezierPath( roundedRect: rect, cornerRadius: radius ) :
        UIBezierPath( rect: rect )
    if width > 0 {
        path.lineWidth = width
    }
    path.stroke()
}

func rectangleFill( rect: Rect, fill: UIColor = UIColor.blackColor(), width: CGFloat = 0, radius: CGFloat = 0 ) { // Fill & stroke?
    let path = radius > 0 ?
        UIBezierPath( roundedRect: CGRectMake(CGFloat(rect.0), CGFloat(rect.1), CGFloat(rect.2), CGFloat(rect.3)) , cornerRadius: radius ) :
        UIBezierPath( rect: CGRectMake(CGFloat(rect.0), CGFloat(rect.1), CGFloat(rect.2), CGFloat(rect.3))  )
    if width > 0 {
        path.lineWidth = width
        path.stroke()
    }
    fill.setFill()
    path.fill()
}


func ellipse( rect: Rect, width: CGFloat = 0 ) {
    let path = UIBezierPath( ovalInRect: CGRectMake(CGFloat(rect.0), CGFloat(rect.1), CGFloat(rect.2), CGFloat(rect.3)) )
    if width > 0 {
        path.lineWidth = width
    }
    path.stroke()
}



func ellipseFill( rect: Rect, _ fill: UIColor = UIColor.blackColor(), _ width: CGFloat = 0 ) {
    let path = UIBezierPath( ovalInRect: CGRectMake(CGFloat(rect.0), CGFloat(rect.1), CGFloat(rect.2), CGFloat(rect.3)) )
    if width > 0 {
        path.lineWidth = width
        path.stroke()
    }
    fill.setFill()
    path.fill()
}

func poly( points: [CGPoint], /*at:CGPoint? = nil,*/ width: CGFloat = 0 ) {
    let path = UIBezierPath()
//    path.lineCapStyle = kCGLineCapRound
//    path.lineJoinStyle = kCGLineJoinRound // kCGLineJoinBevel
    //    path.miterLimit = 60
    path.moveToPoint(points[0])
    for var i=1; i < points.count; i++ {
        path.addLineToPoint(points[i])
    }
    /*
    if let p = at {
    path.applyTransform(CGAffineTransformMake(1, 0, 0, 1, p.x, p.y)) // moveTo(x,y)
    }
    */
    if width > 0 {
        path.lineWidth = width
    }
    path.stroke()
}

func polyFill( points: [CGPoint], fill: UIColor = UIColor.blackColor() ) {
    let path = UIBezierPath()
//    path.lineCapStyle = kCGLineCapRound
//    path.lineJoinStyle = kCGLineJoinRound // kCGLineJoinBevel
    path.moveToPoint(points[0])
    for var i=1; i < points.count; i++ {
        path.addLineToPoint(points[i])
    }
    path.closePath()
    fill.setFill()
    path.fill()
}


func arc( center: CGPoint, radius: CGFloat, width: CGFloat = 0 ) {
    let r = M_PI_4 / 2.0
    let path = UIBezierPath()
    path.addArcWithCenter(center, radius: radius, startAngle: CGFloat(r), endAngle: CGFloat(M_PI - r), clockwise: true)
    if width > 0 {
        path.lineWidth = width
    }
    path.stroke()
}

func arcFill( center: CGPoint, radius: CGFloat, fill: UIColor = UIColor.blackColor() ) {
    let r = M_PI_4 / 2.0
    let path = UIBezierPath()
    path.addArcWithCenter(center, radius: radius, startAngle: CGFloat(r), endAngle: CGFloat(M_PI - r), clockwise: true)
    fill.setFill()
    path.fill()
}


func curve( points: [CGPoint], width: CGFloat = 0 ) {
    let path = UIBezierPath()
    //    path.flatness = 2
    path.moveToPoint(points[0])
    for var i=1; i < points.count-1; i += 2 {
        path.addQuadCurveToPoint(points[i], controlPoint: points[i+1])
    }
    if width > 0 {
        path.lineWidth = width
    }
    path.stroke()
}

func curveFill( points: [CGPoint], fill: UIColor = UIColor.blackColor(), width: CGFloat = 0  ) {
    let path = UIBezierPath()
    path.moveToPoint(points[0])
    for var i=1; i < points.count-1; i += 2 {
        path.addQuadCurveToPoint(points[i], controlPoint: points[i+1])
    }
    path.closePath()
    fill.setFill()
    path.fill()
    if width > 0 {
        path.lineWidth = width
        path.stroke()
    }
}
