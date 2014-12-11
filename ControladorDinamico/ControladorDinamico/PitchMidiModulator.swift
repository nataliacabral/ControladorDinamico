//
//  PitchMidiModulator.swift
//  ControladorDinamico
//
//  Created by Sergio Sette on 12/11/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import AVFoundation

class PitchMidiModulator : MidiModulator
{
    var sampler:Sampler?
    var currentPitch:UInt16 = 0

    init()
    {
        
    }
    
    func modulate(modulation:Float)
    {
        let intModulation = UInt16(modulation * 16383)
        if (currentPitch != intModulation)
        {
            self.currentPitch = intModulation
            NSLog("Sending MIDI controller 1 (pitchbend) with value %u", intModulation)
            self.sampler?.sampler().sendPitchBend(intModulation, onChannel: 0)
        }
    }
    func startModulator()
    {
        self.currentPitch = 0
    }
    
    func setSampler(sampler: Sampler) {
        self.sampler = sampler
    }
}