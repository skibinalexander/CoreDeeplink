//
//  DeeplinkCoordinatorProtocol.swift
//  
//
//  Created by skibinalexander on 04.11.2022.
//

// MARK: - DeeplinkHandler

import Swinject
import Foundation

public protocol DeeplinkProtocol {
    
    associatedtype S: RawRepresentable where S.RawValue == String
    associatedtype F: RawRepresentable where F.RawValue == String
    
    /// Кешированный Url перехода для отложенного вызова
    static func handleCacheUrl() -> URL?
    
    /// Кешированный Container для передачи контейнера с параметрами
    static func handleCacheContainer() -> Container?
    
    /// Обработать deeplinl
    /// - Parameter url: Url ссылка
    static func handle(
        url: URL,
        scheme: S,
        isCacheUrl: ((F) -> Bool)?
    ) -> Self?
    
}

public protocol DeeplinkCoordinatorProtocol {
    
    ///
    /// - Parameter url: Url - deeplink
    /// - Returns: Флаг обработки ссылки
    @discardableResult func handleURL(_ url: URL) -> Bool
    
}

// MARK: - DeeplinkBuilder

enum DeeplinkBuilderError: Error {
    case wrongBuild
}

public protocol DeeplinkBuilder {
    
    // MARK: - Implementation
    
    /// Build схема
    func set<S: RawRepresentable>(scheme: S) -> Self where S.RawValue == String
    
    /// Build фича
    func set<F: RawRepresentable>(feature: F) -> Self
    
    /// Build параметры фичи
    func set(parameters: Dictionary<String, String>) -> Self
    
    /// Сконфигурировать Url
    func build() throws -> URL
    
}
