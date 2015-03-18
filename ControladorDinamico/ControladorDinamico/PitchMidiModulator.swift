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
    var pitchbendSet:Bool = false

    init()
    {
    
    }
    
    func modulate(modulation:Float)
    {
        if (!pitchbendSet && SoundManager.sharedInstance.audioEngine.running) {
            self.sampler?.sampler().sendController(100, withValue: 0, onChannel: 0)
            self.sampler?.sampler().sendController(101, withValue: 0, onChannel: 0)
            self.sampler?.sampler().sendController(6, withValue: 14, onChannel: 0)
            self.sampler?.sampler().sendController(100, withValue: 127, onChannel: 0)
            pitchbendSet = true
        }
        let intModulation = UInt16(modulation * 16383)
        if (currentPitch != intModulation && SoundManager.sharedInstance.audioEngine.running)
        {
            self.currentPitch = intModulation
            //NSLog("Sending MIDI controller 1 (pitchbend) with value %u", intModulation)
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