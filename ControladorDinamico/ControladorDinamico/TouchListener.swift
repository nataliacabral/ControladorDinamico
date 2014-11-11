//
//  TouchListener.swift
//  ControladorDinamico
//
//  Created by Sergio Sette on 11/10/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

@objc protocol TouchListener {
    func touchBegan()
    func touchMoved(recognizer:UIPanGestureRecognizer)
    func touchEnded()
}