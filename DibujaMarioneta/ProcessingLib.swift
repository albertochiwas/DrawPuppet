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


typealias  MPRect = (x: Int, y: Int, width: Int, height: Int)
typealias MPPoint = (x: Int, y: Int)

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


func random( min: Int, max: Int ) -> Int
{
    return min + Int(arc4random_uniform(UInt32(max - min + 1)))
}


let PI_RADIANS = Float(180.0 * M_PI)

func radians( degrees: Float ) -> Float {
    return Float( degrees ) / PI_RADIANS
}


func line(x1: Int, _ y1: Int, _ x2: Int, _ y2: Int, _ width: Int = 2) {
    line(MPPoint(x: x1, y: y1), end: MPPoint(x: x2, y: y2), width: width)
}

func line(start: MPPoint, end: MPPoint, width: Int = 2) {
    let path = UIBezierPath()
//    path.lineCapStyle = kCGLineCapRound
    path.moveToPoint(CGPointMake(CGFloat(start.x),CGFloat(start.y)))
    path.addLineToPoint(CGPointMake(CGFloat(end.x),CGFloat(end.y)))
    if width > 0 {
        path.lineWidth = CGFloat(width)
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

func rectangleFill( rect: CGRect, fill: UIColor = UIColor.blackColor(), width: CGFloat = 0, radius: CGFloat = 0 ) { // Fill & stroke?
    let path = radius > 0 ?
        UIBezierPath( roundedRect: rect, cornerRadius: radius ) :
        UIBezierPath( rect: rect )
    if width > 0 {
        path.lineWidth = width
        path.stroke()
    }
    fill.setFill()
    path.fill()
}


func ellipse( rect: CGRect, width: CGFloat = 0 ) {
    let path = UIBezierPath( ovalInRect: rect )
    if width > 0 {
        path.lineWidth = width
    }
    path.stroke()
}

func ellipseFill( rect rect: MPRect, fill: UIColor = UIColor.blackColor(), width: Int = 0 ) {
    ellipseFill(rect, fill, width)
}

func ellipseFill( r: MPRect, _ f: UIColor = UIColor.blackColor(), _ w: Int = 0 ) {
    let path = UIBezierPath( ovalInRect: CGRectMake(CGFloat(r.x), CGFloat(r.y), CGFloat(r.width), CGFloat(r.height)) )
    if w > 0 {
        path.lineWidth = CGFloat(w)
        path.stroke()
    }
    f.setFill()
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