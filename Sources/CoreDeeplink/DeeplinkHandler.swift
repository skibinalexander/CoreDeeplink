//
//  DeeplinkCoordinatorProtocol.swift
//  
//
//  Created by skibinalexander on 04.11.2022.
//

// MARK: - DeeplinkHandler

import Foundation

public protocol DeeplinkCoordinatorProtocol {
    
    ///
    /// - Parameter url: Url - deeplink
    /// - Returns: Флаг обработки ссылки
    @discardableResult func handleURL(_ url: URL) -> Bool
    
}
