//
//  TabBarCoordinator.swift
//  ForaArchitecture
//
//  Created by Dmitriy.K on 09.02.2022.
//

import UIKit
import DITranquillity
import RxSwift
import ForaArchitecture

final class TabBarCoordinator: BaseCoordinator {
    
    // MARK: - Private Properties
    
    private typealias Flow = (Coordinator, Presentable)
    
    private let container: DIContainer
    private let router: TabBarRouter
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializer
    
    init(router: TabBarRouter, container: DIContainer) {
        self.router = router
        self.container = container
        super.init()
    }
    
    override func start(with option: (any DeepLinkOption)?) {

    }
    
    // MARK: - Private Methods
 
}
