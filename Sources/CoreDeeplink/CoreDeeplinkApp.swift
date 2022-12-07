//
//  CoreDeeplink.swift
//  
//
//  Created by skibinalexander on 04.11.2022.
//

import Foundation

public enum AppDeeplink {
    case wallets, p2p
    
    var identifier: String {
        switch self {
        case .wallets:
            return "com.cryptoner.wallets.deeplinkHandler"
        case .p2p:
            return "com.cryptoner.p2p.deeplinkHandler"
        }
    }
    
    var scheme: String {
        switch self {
        case .wallets:
            return "wallets.cryptoner.space"
        case .p2p:
            return "p2p.cryptoner.space"
        }
    }
}

public struct CoreDeeplinkApp {
    
    // MARK: - Public Static
    
    /// Кеш необработанных линков
    public static func handleCacheUrl() -> URL? {
        return cacheUrl
    }
    
    /// Обработать deeplinl
    /// - Parameter url: Url ссылка
    public static func handle(
        url: URL,
        app: AppDeeplink,
        isCacheUrl: ((Feature) -> Bool)? = nil
    ) -> CoreDeeplinkApp? {
        guard
            url.absoluteString.hasPrefix("\(app.scheme)://"),
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

extension CoreDeeplinkApp {
    
    /// Схема фичей
    private enum Scheme: String {
        
        /// UseCase - Кошельки
        case wallets
        
        /// UseCase - Истории
        case stories
        
        /// UserCase - Профиль пользователя
        case profile
        
        /// UseCase - Транзакции
        case transactions
        
        /// Устройства
        case devices
        
        /// P2PMarket
        case p2pMarket = "p2p_market"
        
        /// Поддержка
        case support
        
        /// Ввод данных
        case inputs
        
    }
    
    private enum Path: String {
        case create = "/create"
        case recovery = "/recovery"
        case keys = "/keys"
        case open = "/open"
        case send = "/send"
        case receive = "/receive"
        case detail = "/detail"
        case list = "/list"
        case chat = "/chat"
        case actions = "/actions"
        case virtual = "/virtual"
        case virtualPush = "/virtual/push"
        case virtualPull = "/virtual/pull"
        case inputsAmount = "/amount"
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
        
        /// Список устройств
        case listDevices = "devices/list"
        
        /// Открыть фичу P2PMarketList
        case listP2PMarket = "p2p_market/list"
        
        /// Чат поддержки
        case supportChat = "support/chat"
        
        /// P2P экран действий
        case p2pMarketActions = "p2p_market/actions"
        
        /// Пополнить виртуальный кошелёк
        case pushVirtualWallets = "wallets/virtual/push"
        
        /// Вывести средства с виртуального кошелька
        case pullVirtualWallets = "wallets/virtual/pull"
        
        /// Ввод значение стоимости
        case inputsAmount = "inputs/amount"
        
    }
    
}

// MARK: - DeeplinkBuilder

public final class DeeplinkBuilder {
    
    // MARK: - Public
    
    enum BuilderError: Error {
        case wrongBuild
    }
    
    // MARK: - Private Propertioes
    
    private var app: AppDeeplink!
    private var feature: CoreDeeplinkApp.Feature?
    private var parameters: Dictionary<String, String>?
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Implementation
    
    public func set(app: AppDeeplink) -> Self {
        self.app = app
        return self
    }
    
    public func set(feature: CoreDeeplinkApp.Feature) -> Self {
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
        
        guard var url = URLComponents(string: "\(app.scheme)://\(feature.rawValue)") else {
            throw BuilderError.wrongBuild
        }
        
        url.queryItems = parameters?.compactMap { key, value in .init(name: key, value: value) } ?? []
        
        guard let url = url.url else {
            throw BuilderError.wrongBuild
        }
        
        return url
    }
    
}
