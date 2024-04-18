//
//  NetworkPart.swift
//  TheVoice
//
//  Created by alexandr galkin on 11.10.2022.
//

import DITranquillity

final class NetworkPart: DIPart {
    static func load(container: DIContainer) {
        container.register(EnvironmentManagerImpl.init).as(EnvironmentManager.self).lifetime(.perRun(.weak))
        container.register(RequestInterceptorImpl.init).as(RequestInterceptor.self).lifetime(.perRun(.weak))
        container.register(NetworkManagerImpl.init).as(NetworkManager.self).lifetime(.perRun(.weak))
        container.register(NetworkResponseHandlerImpl.init).as(NetworkResponseHandler.self).lifetime(.perRun(.weak))
        container.register(NetworkQueryImpl.init).as(NetworkQuery.self).lifetime(.perRun(.weak))
        container.register(RequestExecutorImpl.init).as(RequestExecutor.self).lifetime(.perRun(.weak))
    }
}
