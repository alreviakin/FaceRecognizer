//
//  ModelPart.swift
//  ForaArchitecture
//
//  Created by Georgii Kazhuro on 07.04.2021.
//

import DITranquillity
import ForaArchitecture

final class ModelPart: DIPart {
    static func load(container: DIContainer) {
        container.register(EventsHandler.init)
        container.register(SharedStore.init(eventsHandler:)).lifetime(.perContainer(.strong))
    }
}

extension SharedStore where State == AppState, Event == AppEvent {
    convenience init(eventsHandler: EventsHandler<AppEvent, AppState>) {
        self.init(initialState: .init(), eventsHandler: eventsHandler)
    }
}
