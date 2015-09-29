//
//  DrawingView.swift
//  DibujaMarioneta
//
//  Created by Alberto Pacheco on 22/09/15.
//  Copyright © 2015 Alberto Pacheco. All rights reserved.
//

import Foundation
import UIKit

typealias MPColor = UIColor

class DrawingView: UIView {
    
    override func drawRect(r: CGRect)
    {
        ellipseFill(rect: (x: 10, y: 10, width: 100, height: 100), fill: MPColor(200), width: 6)
        line(10,10,120,120)
    }
    
} // DrawingView class