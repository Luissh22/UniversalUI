//
//  RefreshableScrollView.swift
//  
//
//  Created by Luis Abraham on 2020-12-11.
//

import SwiftUI

public struct RefreshableScrollView<Content: View>: UIViewRepresentable {
    
    private let uiScrollView: UIScrollView
    private let uiRefreshControl: UIRefreshControl
    private let refreshAction: () -> Void
    
    public init(showsVerticalIndicator: Bool = true,
         refreshAction: @escaping () -> Void,
         @ViewBuilder content: () -> Content) {
        
        self.refreshAction = refreshAction
        self.uiScrollView = UIScrollView()
        self.uiRefreshControl = UIRefreshControl()
        self.uiScrollView.showsVerticalScrollIndicator = showsVerticalIndicator
        self.uiScrollView.refreshControl = self.uiRefreshControl
        
        // Creating a hosting controller for our SwiftUI view
        let hostingController = UIHostingController(rootView: content())
        // Turn on AutoLayout
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        // Add our SwiftUI view to the scroll view
        self.uiScrollView.addSubview(hostingController.view)
        
        // Constraints
        let constraints = [
            hostingController.view.leadingAnchor.constraint(equalTo: self.uiScrollView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: self.uiScrollView.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: self.uiScrollView.contentLayoutGuide.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: self.uiScrollView.contentLayoutGuide.bottomAnchor),
            hostingController.view.widthAnchor.constraint(equalTo: self.uiScrollView.widthAnchor)
        ]
        
        self.uiScrollView.addConstraints(constraints)
    }
    
    
    public func makeUIView(context: Context) -> UIScrollView {
        self.uiScrollView.refreshControl?.addTarget(context.coordinator,
                                                    action: #selector(context.coordinator.handleRefreshControl),
                                                    for: .valueChanged)
        return self.uiScrollView
    }
    
    public func updateUIView(_ uiView: UIScrollView, context: Context) {
        
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(withRefreshControl: uiRefreshControl, refreshAction: refreshAction)
    }
    
    final public class Coordinator {
        
        private let refreshControl: UIRefreshControl?
        private let refreshAction: () -> Void
        
        
        public init(withRefreshControl refreshControl: UIRefreshControl, refreshAction: @escaping () -> Void) {
            self.refreshControl = refreshControl
            self.refreshAction = refreshAction
        }
        
        @objc func handleRefreshControl() {
            refreshAction()
            
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
}

