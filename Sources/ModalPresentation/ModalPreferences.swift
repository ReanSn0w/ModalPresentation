//
//  SwiftUIView.swift
//  
//
//  Created by Дмитрий Папков on 16.03.2021.
//

import SwiftUI

public class ModalPreferences: ObservableObject {
    public var allowsDismiss: Bool
    public var didAttemptToDissmiss: (() -> Void)?
    var parentViewController: UIViewController? = nil
    
    init(allowsDismiss: Bool, didAttemptToDissmiss: (() -> Void)?) {
        self.allowsDismiss = allowsDismiss
        self.didAttemptToDissmiss = didAttemptToDissmiss
    }
    
    public func dismissNow(animated: Bool = true) {
        self.allowsDismiss = true
        self.parentViewController?.dismiss(animated: animated)
    }
}

struct ModalPreferencesEnvironmentKey: EnvironmentKey {
    static let defaultValue: ModalPreferences? = nil
}

public extension EnvironmentValues {
    var modalPreferences: ModalPreferences? {
        get {
            return self[ModalPreferencesEnvironmentKey]
        }
        set {
            self[ModalPreferencesEnvironmentKey] = newValue
        }
    }
}
