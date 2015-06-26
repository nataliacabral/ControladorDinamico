//
//  MidiModulator.swift
//  ControladorDinamico
//
//  Created by Sergio Sette on 12/11/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import AVFoundation

@objc protocol MidiModulator : Modulator
{
    func setSampler(sampler:Sampler)
}