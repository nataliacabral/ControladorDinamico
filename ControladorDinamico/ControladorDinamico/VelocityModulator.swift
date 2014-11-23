//
//  VelocityModulator.swift
//  ControladorDinamico
//
//  Created by Sergio Sette on 11/23/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import AVFoundation

class VelocityModulator : Modulator
{
    var node:AVAudioUnitVarispeed = AVAudioUnitVarispeed()
    
    func modulate(modulation:Float)
    {
        self.node.rate = (modulation * 3.75) + 0.25
    }
    func startModulator()
    {
        node.rate = 1.0
    }
    
    func audioNode() -> AVAudioNode {
        return self.node
    }
}