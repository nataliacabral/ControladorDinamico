//
//  Pannable.swift
//  ControladorDinamico
//
//  Created by Sergio Sette on 11/15/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

@objc protocol Pannable
{
    func panStarted();
    func panMoved(translation:CGPoint);
    func panEnded();
}