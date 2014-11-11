//
//  Collidable.swift
//  ControladorDinamico
//
//  Created by Sergio Sette on 11/10/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation

@objc protocol Collidable
{
    func collidesWith(object:AnyObject) -> Bool
}