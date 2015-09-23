//
//  DrawingView.swift
//  DibujaMarioneta
//
//  Created by Alberto Pacheco on 22/09/15.
//  Copyright © 2015 Alberto Pacheco. All rights reserved.
//

import Foundation
import UIKit

typealias color = UIColor

class DrawingView: UIView {
    
    override func drawRect(rect: CGRect)
    {
        ellipseFill((10,10,100,100), color(200), 6)
    }
    
} // DrawingView class