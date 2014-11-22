//
//  ModulatorNode.swift
//  ControladorDinamico
//
//  Created by Sergio Sette on 11/21/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import AVFoundation

@objc protocol ModulatorNode
{
    func setModule(module:Float)
    func addModulator(modulator:Modulator)
}