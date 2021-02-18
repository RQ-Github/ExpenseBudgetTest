//
//  DIContainer.swift
//  Expense
//
//  Created by Ray Qu on 14/02/21.
//

import Foundation
import Swinject

protocol DIContainer {
    func register<Service>(type: Service.Type, factory: @escaping (Resolver) -> Service)
    func resolve<Service>() -> Service
}
class DIContainerImpl : DIContainer {
    static let shared = DIContainerImpl();
    lazy var swinjectContainer : Container = {
        Container()
    }();
    
    private init() {
    }

    public func register<Service>(type: Service.Type, factory: @escaping (Resolver) -> Service)
    {
        swinjectContainer.register(type, factory: factory);
    }
    
    public func resolve<Service>() -> Service
    {
        return swinjectContainer.resolve(Service.self)!;
    }
}
