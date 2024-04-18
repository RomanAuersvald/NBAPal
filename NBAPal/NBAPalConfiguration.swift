//
//  NBAPalConfiguration.swift
//  NBAPal
//
//  Created by Roman Auersvald on 18.04.2024.
//

import Foundation


public struct NBAPalConfiguration {
    let networkConfiguration = NetworkConfiguration()
    let resultsPerPage = 35
    let isShowingPlayerID = false
}

public struct NetworkConfiguration {
    let apiSecret = "741c5815-4fec-475a-9c62-ad0a73b7907a"
    let backeddURL = "https://api.balldontlie.io/v1/players"
}
