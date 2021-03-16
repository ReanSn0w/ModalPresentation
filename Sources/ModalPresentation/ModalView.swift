//
//  ModalView.swift
//
//
//  Created by Дмитрий Папков on 16.03.2021.
//

import SwiftUI

public extension View {
    func modalPresentation(
        allowsDismiss: Bool = false,
        didAttemptToDissmiss: (()->Void)? = nil
    ) -> some View {
        ModalView(allowsDismiss: allowsDismiss, didAttemptToDissmiss: didAttemptToDissmiss) { self }
    }
}

struct ModalView<Content: View>: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    
    @ObservedObject var modalPreferences: ModalPreferences
    let view: () -> Content
    
    init(
        allowsDismiss: Bool = true,
        didAttemptToDissmiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.modalPreferences = .init(
            allowsDismiss: allowsDismiss,
            didAttemptToDissmiss: didAttemptToDissmiss)
        
        self.view = content
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        UIHostingController(rootView: view().environment(\.modalPreferences, modalPreferences))
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if let parent = uiViewController.parent {
            parent.presentationController?.delegate = context.coordinator
            modalPreferences.parentViewController = parent
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIAdaptivePresentationControllerDelegate {
        let parent: ModalView
        
        init(_ parent: ModalView) {
            self.parent = parent
        }
        
        func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
            return parent.modalPreferences.allowsDismiss
        }
        
        func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
            if let attemptAction = parent.modalPreferences.didAttemptToDissmiss {
                attemptAction()
            }
        }
    }
}

struct ModalView_Previews: PreviewProvider {
    static var previews: some View {
        Color.white
            .sheet(isPresented: .constant(true)) {
                ModalView(allowsDismiss: false) { Color.red }
            }
    }
}
