//
//  ARViewProvider.swift
//  FaceRecognizer
//
//  Created by Алексей Ревякин on 18.04.2024.
//

import RxSwift
import ForaArchitecture

protocol ARViewProvider {
    var state: Observable<ARViewProviderState> { get }
    var currentState: ARViewProviderState { get }
}

final class ARViewProviderImpl: ARViewProvider {
    lazy var state = $currentState.asObservable()

    @RxPublished private(set) var currentState = ARViewProviderState()
}
