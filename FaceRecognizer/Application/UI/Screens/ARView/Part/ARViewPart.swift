//
//  ARViewPart.swift
//  FaceRecognizer
//
//  Created by Алексей Ревякин on 18.04.2024.
//

import DITranquillity
import SwiftUI

final class ARViewPart: DIPart {
    static func load(container: DIContainer) {
        container.register(ARViewProviderImpl.init).as(ARViewProvider.self).lifetime(.objectGraph)
        container.register(ARViewViewModel.init(provider:)).lifetime(.objectGraph)
        container.register(ARViewView.init(viewModel:)).lifetime(.objectGraph)
        container.register {
            ARViewDependency(
                viewController: UIHostingController(rootView: $0),
                viewModel: $1
            )
        }.lifetime(.prototype)
    }
}

struct ARViewDependency {
    let viewController: UIHostingController<ARViewView>
    let viewModel: ARViewViewModel
}
