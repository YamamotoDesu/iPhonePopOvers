//
//  iOSPopover.swift
//  iPhonePopOvers
//
//  Created by 山本響 on 2023/03/28.
//

import SwiftUI

// - Enabling Popover for iOS
extension View {
    @ViewBuilder
    func iOSPopover<Content: View>(isPresented: Binding<Bool>,arrowDirection: UIPopoverArrowDirection,@ViewBuilder content: @escaping ()->Content)->some View{
        self
            .background {
                PopOverController(isPresented: isPresented, arrowDirection: arrowDirection, content: content())
            }
    }
}


/// - Popover Helper
fileprivate struct PopOverController<Content: View>: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    var arrowDirection: UIPopoverArrowDirection
    var content: Content
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        controller.view.backgroundColor = .clear
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented {
            /// - Presenting Popover
//            let controller = UIHostingController(rootView: content)
            let controller = CustomHostingView(rootView: content)
            controller.view.backgroundColor = .clear
            controller.modalPresentationStyle = .popover
            controller.popoverPresentationController?.permittedArrowDirections = arrowDirection
            
            /// - Connecting Delegate
            controller.presentationController?.delegate = context.coordinator
            
            /// - We head to Attach the Source View So that it will show Arrow At Correct Position
            controller.popoverPresentationController?.sourceView = uiViewController.view
            /// - Simply Presenting PopOver Controller
            uiViewController.present(controller, animated: true)
        }
    }
    
    /// - Forcing it  to show Popover using PresentationDelegate
    class Coordinator: NSObject, UIPopoverPresentationControllerDelegate {
        var parent: PopOverController
        init(parent: PopOverController) {
            self.parent = parent
        }
        
        func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
            return .none
        }
        
        /// - Observing the status of the Popover
        /// - When it is dismissed updating the isPresented State
        func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
            parent.isPresented = false
        }
    }
}

/// - Custom Hosting Controller for Wrapping to it's SwiftUI View Size
fileprivate class CustomHostingView<Content: View>: UIHostingController<Content>{
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = view.intrinsicContentSize
    }
}