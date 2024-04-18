//
//  ARViewView.swift
//  FaceRecognizer
//
//  Created by Алексей Ревякин on 18.04.2024.
//

import SwiftUI

struct ARViewView: View {
    
    @ObservedObject private var viewModel: ARViewViewModel
    
    init(viewModel: ARViewViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        EmptyView()
    }
}
