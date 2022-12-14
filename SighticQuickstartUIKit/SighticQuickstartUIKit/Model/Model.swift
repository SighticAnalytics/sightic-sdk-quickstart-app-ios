//
//  Copyright © 2022 Sightic Analytics AB All rights reserved.
//

import Combine
import SighticAnalytics

struct SighticInferenceViewConfiguration {
    var showInstructions: Bool = false
}

enum AppState {
    case start
    case test(SighticInferenceViewConfiguration)
    case waiting
    case result(SighticInference, SighticInferenceRecording)
    case error(SighticError)
    case feedback(SighticInference, SighticInferenceRecording)
}

class Model {
    @Published var appState: AppState = .start
}

var model = Model()
