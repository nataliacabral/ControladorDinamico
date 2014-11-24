//
//  EQModulator.swift
//  ControladorDinamico
//
//  Created by Sergio Sette on 11/23/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import AVFoundation

class EQModulator : Modulator
{
    var node:AVAudioUnitEQ = AVAudioUnitEQ(numberOfBands: 1)
    
    func modulate(modulation:Float)
    {
        let nodeParam = node.bands[0] as AVAudioUnitEQFilterParameters
        nodeParam.frequency = modulation * 440000
    }
    func startModulator()
    {
        let nodeParam = node.bands[0] as AVAudioUnitEQFilterParameters
        nodeParam.filterType = AVAudioUnitEQFilterType.Parametric
    }
    
    func audioNode() -> AVAudioNode {
        return self.node
    }
}