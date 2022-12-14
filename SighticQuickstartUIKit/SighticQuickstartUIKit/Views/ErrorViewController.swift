//
//  Copyright © 2022 Sightic Analytics AB All rights reserved.
//

import UIKit
import SighticAnalytics

class ErrorViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let sv = UIQuickstartStackview()
        view.addSubview(sv)
        NSLayoutConstraint.activate([
            sv.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sv.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            sv.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            sv.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])

        let errorText: String
        if case .error(let sighticError) = model.appState {
            errorText = "Error: \(sighticError.localizedDescription)"
        } else {
            errorText = "<error not available>"
        }

        let title = UIQuickstartTitle(title: "Sightic SDK Quickstart")
        let spacer1 = UIQuickstartSpacer()
        let body = UIQuickstartBody(text: "ErrorView")
        let result = UIQuickstartBody(text: errorText)
        let button = UIQuickstartButton(title: "Go to start", action: {
            model.appState = .start
        })
        let spacer2 = UIQuickstartSpacer()

        sv.addArrangedSubview(title)
        sv.addArrangedSubview(spacer1)
        sv.addArrangedSubview(body)
        sv.addArrangedSubview(result)
        if case let .error(sighticError) = model.appState, case let .recordingFailed(recordingError) = sighticError {
            sv.addArrangedSubview(createFailView(recordingError))
        }
        sv.addArrangedSubview(button)
        sv.addArrangedSubview(spacer2)

        NSLayoutConstraint.activate([
            spacer2.heightAnchor.constraint(equalTo: spacer1.heightAnchor)
        ])
    }
    
    func createFailView(_ recordingError: SighticRecordingError) -> UIView {
        let label = UIQuickstartBody(text: "Test failed because \(recordingError.reasonString).")
        label.textColor = .red
        return label
    }
}

extension SighticRecordingError {
    public var reasonString: String {
        switch self {
        case .interrupted:
            return "the recording was interrupted"
        case let .alignment(alignmentStatus):
            switch alignmentStatus {
            case .noFaceTracked:
                return "there was no face in the frame"
            case .tooFarAway:
                return "the phone was held too far away"
            case .noAttention:
                return "the user was not looking at the display"
            case .blink:
                return "the user blinked too much"
            case let .notCentered(offset):
                switch offset {
                case .down:
                    return "the phone was held too low"
                case .up:
                    return "the phone was held too high"
                case .left:
                    return "the phone was held too far to the left"
                case .right:
                    return "the phone was held too far to the right"
                case .noOffset:
                    return ""
                @unknown default:
                    return ""
                }
            case .ok:
                return ""
            case let .headTilted(tilt):
                switch tilt {
                case .Up:
                    return "the user looked up"
                case .Down:
                    return "the user looked down"
                case .Left:
                    return "the user looked left"
                case .Right:
                    return "the user looked right"
                case .NoTilt:
                    return ""
                @unknown default:
                    return ""
                }
            @unknown default:
                return ""
            }
        @unknown default:
            return ""
        }
    }
}
