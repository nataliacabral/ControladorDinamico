//
//  EQModulator.swift
//  ControladorDinamico
//
//  Created by Sergio Sette on 11/23/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import AVFoundation

class EQModulator : NodeModulator
{
    var node:AVAudioUnitEQ = AVAudioUnitEQ(numberOfBands: 1)
    
    func modulate(modulation:Float)
    {
        let nodeParam = node.bands[0] as AVAudioUnitEQFilterParameters
        nodeParam.frequency = 20 + (800 * modulation)
    }
    func startModulator()
    {
        let nodeParam = node.bands[0] as AVAudioUnitEQFilterParameters
        nodeParam.bypass = false
//        nodeParam.frequency = 5000.0
        nodeParam.gain = -10
        nodeParam.filterType = AVAudioUnitEQFilterType.LowPass
    }
    
    func audioNode() -> AVAudioNode {
        return self.node
    }
}