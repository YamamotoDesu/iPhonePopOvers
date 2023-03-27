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
    /// - View Properties
    @State private var alrearyPresented: Bool = false
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        controller.view.backgroundColor = .clear
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
        if alrearyPresented {
            /// - Updating SwiftUI View, when it's Changed
            if let hostingController = uiViewController.presentedViewController as? CustomHostingView<Content> {
                hostingController.rootView = content
                /// - Updating View Size when it's Updated
                /// - 0r you can define your own size in SwiftUI  View
                hostingController.preferredContentSize = hostingController.view.intrinsicContentSize
            }
            
            /// - Close View, if it's toggled back
            if !isPresented {
                /// - Closing Popover
                uiViewController.dismiss(animated: true) {
                    // - Rsetting alredyPresented State
                    alrearyPresented = false
                }
            }
        } else {
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

        /// - When the popover is presented, updating the alredyPresented State
        func presentationController(
            _ presentationController: UIPresentationController,
            willPresentWithAdaptiveStyle style: UIModalPresentationStyle,
            transitionCoordinator: UIViewControllerTransitionCoordinator?
        ) {
            
            DispatchQueue.main.async {
                self.parent.alrearyPresented = true
            }
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
