//
//  Touchable.swift
//  ControladorDinamico
//
//  Created by Sergio Sette on 11/15/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

@objc protocol Touchable
{
    func touchStarted(position:CGPoint)
    func touchEnded(position:CGPoint)
    func touchMoved(position:CGPoint)
    func touchCancelled(position:CGPoint)
}