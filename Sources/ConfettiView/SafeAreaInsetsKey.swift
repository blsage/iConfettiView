//
//  SafeAreaInsetsKey.swift
//  ConfettiView
//
//  Created by Benjamin Sage on 12/15/24.
//

import SwiftUI
import UIKit

private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        .init() // Provide a default, nonisolated value
    }
}

extension EnvironmentValues {
    @MainActor
    var safeAreaInsets: EdgeInsets {
        get {
            let safeAreaInsets = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first(where: { $0.isKeyWindow })?.safeAreaInsets ?? .zero

            return EdgeInsets(
                top: safeAreaInsets.top,
                leading: safeAreaInsets.left,
                bottom: safeAreaInsets.bottom,
                trailing: safeAreaInsets.right
            )
        }
    }
}
