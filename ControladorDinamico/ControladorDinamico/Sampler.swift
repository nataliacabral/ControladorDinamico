//
//  Sampler.swift
//  ControladorDinamico
//
//  Created by Sergio Sette on 11/21/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import AVFoundation

@objc protocol Sampler
{
    func sampler() -> AVAudioUnitSampler
    func playSound()
    func stopSound()
    func startSampler()
    func getNote() -> UInt8
}