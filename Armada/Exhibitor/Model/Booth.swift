//
//  Booth.swift
//  Armada
//
//  Created by Boran Karaca on 2018-11-11.
//  Copyright © 2018 THS Armada. All rights reserved.
//

struct Booth: Codable {
    let location: FairLocation
    let name: String?
    let comment: String?
    let days: [String]
}
