//
//  Touchable.swift
//  ControladorDinamico
//
//  Created by Sergio Sette on 11/15/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation

@objc protocol Touchable
{
    func touchStarted();
    func touchEnded();
}