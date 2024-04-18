//
//  AppEventsHandler.swift
//  ForaArchitecture
//
//  Created by Georgii Kazhuro on 14.07.2021.
//

import RxSwift
import RxRelay
import Foundation
import ForaArchitecture

extension EventsHandler where State == AppState, Event == AppEvent {
    convenience init() {
        self.init { event in
            return nil
        }
    }
}
