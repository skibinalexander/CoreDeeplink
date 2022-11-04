//
//  CoreDeeplink.swift
//  
//
//  Created by skibinalexander on 04.11.2022.
//

import Foundation

public let DeeplinkIdentifier: String = "com.cryptoner.wallet.deeplinkHandler"
public let DeeplinkScheme: String = "wallets.cryptoner"

public struct CoreDeeplinkWalletsApp {
    
    // MARK: - Public Static
    
    /// Кеш необработанных линков
    public static func handleCacheUrl() -> URL? {
        return cacheUrl
    }
    
    /// Обработать deeplinl
    /// - Parameter url: Url ссылка
    public static func handle(url: URL, isCacheUrl: ((Feature) -> Bool)? = nil) -> CoreDeeplinkWalletsApp? {
        guard
            url.absoluteString.hasPrefix("\(DeeplinkScheme)://"),
            let scheme = Scheme(rawValue: url.host ?? ""),
            let path = Path(rawValue: url.path)
        else {
            return nil
        }
        
        let feature: Feature = .init(rawValue: scheme.rawValue + path.rawValue) ?? .none
        
        guard !(isCacheUrl?(feature) ?? false) else {
            cacheUrl = url
            return .init(feature: .none, parameters: URLComponents(string: url.absoluteString)?.queryItems ?? [])
        }
        
        return .init(feature: feature, parameters: URLComponents(string: url.absoluteString)?.queryItems ?? [])
    }
    
    // MARK: - Private Static
    
    /// Кешированный Url перехода deeplink
    private static var cacheUrl: URL?
    
    // MARK: - Propertioes
    
    /// Фича deeplink
    public let feature: Feature
    
    /// Параметры deeplinku
    public let parameters: [URLQueryItem]
    
}

extension CoreDeeplinkWalletsApp {
    
    private enum Scheme: String {
        
        /// UseCase - Кошельки
        case wallets
        
        /// UseCase - Истории
        case stories
        
        /// UserCase - Профиль пользователя
        case profile
        
        /// UseCase - Транзакции
        case transactions
        
    }
    
    private enum Path: String {
        case create = "/create"
        case recovery = "/recovery"
        case keys = "/keys"
        case open = "/open"
        case send = "/send"
        case receive = "/receive"
        case detai = "/detail"
    }
    
    /// Deeplink фунциональновстей
    public enum Feature: String {
        
        /// Неопределенный deeplink
        case none
        
        /// Создание нового кошелька
        case createWallet = "wallets/create"
        
        /// Восстановление кошелька
        case recoveryWallet = "wallets/recovery"
        
        /// Приватные ключи кошельков
        case keysWallets = "wallets/keys"
        
        /// Открытие истории
        case openStory = "stories/open"
        
        /// Открыть профиль пользователя
        case openProfile = "profile/open"
        
        /// Отправить транзакцию
        case sendTransaction = "transactions/send"
        
        /// Получить транзакцию
        case receiveTransaction = "transactions/receive"
        
        /// Детали транзакций
        case detailTransactions = "transactions/detail"
        
    }
    
}

// MARK: - DeeplinkBuilder

public final class DeeplinkBuilder {
    
    // MARK: - Public
    
    enum BuilderError: Error {
        case wrongBuild
    }
    
    // MARK: - Private Propertioes
    
    private var feature: CoreDeeplinkWalletsApp.Feature?
    private var parameters: Dictionary<String, String>?
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Implementation
    
    public func set(feature: CoreDeeplinkWalletsApp.Feature) -> Self {
        self.feature = feature
        return self
    }
    
    public func set(parameters: Dictionary<String, String>) -> Self {
        self.parameters = parameters
        return self
    }
    
    public func build() throws -> URL {
        guard let feature = feature else {
            throw BuilderError.wrongBuild
        }
        
        guard var url = URLComponents(string: "\(DeeplinkScheme)://\(feature.rawValue)") else {
            throw BuilderError.wrongBuild
        }
        
        url.queryItems = parameters?.compactMap { key, value in .init(name: key, value: value) } ?? []
        
        guard let url = url.url else {
            throw BuilderError.wrongBuild
        }
        
        return url
    }
    
}
