//
//  ARViewViewModel.swift
//  FaceRecognizer
//
//  Created by Алексей Ревякин on 18.04.2024.
//

import SwiftUI
import RxSwift

struct ARViewViewInputModel {
    
}

enum ARViewViewOutputModel {
    
}

final class ARViewViewModel: ObservableObject {
    // MARK: - Public

    @Published var input = ARViewViewInputModel()
    let output = PublishSubject<ARViewViewOutputModel>()
    let events = PublishSubject<ARViewViewEvent>()
    
    // MARK: - Private
    
    private var provider: ARViewProvider
    private let disposeBag = DisposeBag()
    
    init(provider: ARViewProvider) {
        self.provider = provider
        
        provider.state
            .observe(on: MainScheduler.instance)
            .compactMap { $0.viewInputData() }
            .subscribe(onNext: { [weak self] data in
                self?.input = data
            }).disposed(by: disposeBag)
    }
    
    func onEvent(_ event: ARViewViewEvent) {
        
    }
}

extension ARViewProviderState {
    func viewInputData() -> ARViewViewInputModel {
        return ARViewViewInputModel()
    }
}
