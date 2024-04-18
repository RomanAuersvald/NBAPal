//
//  NetworkManager.swift
//  NBAPal
//
//  Created by Roman Auersvald on 18.04.2024.
//

import Foundation
import Combine

protocol NetworkManager {
    func getPlayers(perPage: Int, cursor: Int?, searchText: String) -> AnyPublisher<Wrap, Error>
}

