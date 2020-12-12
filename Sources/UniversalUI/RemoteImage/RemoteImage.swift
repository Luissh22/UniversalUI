//
//  RemoteImage.swift
//  
//
//  Created by Luis Abraham on 2020-12-12.
//

import SwiftUI
import Combine

@available(iOS 14.0, *)
public struct RemoteImage<Content: View>: View {
    
    /// Load state for image fetching
    private enum LoadState {
        case loading,
             success(image: UIImage),
             failure
    }
    
    /// Performs the actual loading of image
    private class Loader: ObservableObject {
        /// Serial processing queue
        private let imageProcessingQueue = DispatchQueue(label: "image-processing")
        
        /// Exposing image loader state
        @Published var state = LoadState.loading
        private var cache: ImageCache?
        private var cancellable: AnyCancellable?
        private(set) var isLoading = false
        private var url: URL
        
        init(url: String, cache: ImageCache? = nil) {
            guard let parsedURL = URL(string: url) else {
                fatalError("Unable to parse url: \(url)")
            }
            self.url = parsedURL
            self.cache = cache
        }
        
        deinit {
            cancel()
        }
        
        func load() {
            guard !isLoading else { return }
            
            // Check cache
            if let image = cache?[url] {
                print("Using cache for \(url)")
                state = .success(image: image)
                return
            }
            
            print("Making network call for \(url)")
            cancellable = URLSession.shared.dataTaskPublisher(for: url)
                .subscribe(on: imageProcessingQueue)
                .map { UIImage(data: $0.data) }
                .replaceError(with: nil)
                .handleEvents(receiveSubscription: receiveSubscription,
                              receiveOutput: receiveOutput,
                              receiveCompletion: { _ in self.receiveCancel()},
                              receiveCancel: receiveCancel)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }) { image in
                    self.receiveValue(image)
                }
        }
        
        private func receiveSubscription(_ subscription: Subscription) {
            onStart()
        }
        
        private func receiveOutput(_ image: UIImage?) {
            image.map { cache?[url] = $0 }
        }
        
        private func receiveCancel() {
            onFinish()
        }
        
        private func receiveValue(_ image: UIImage?) {
            if let _image = image {
                state = .success(image: _image)
            } else {
                state = .failure
            }
        }
        
        private func cancel() {
            cancellable?.cancel()
        }
        
        private func onStart() {
            isLoading = true
        }
        
        private func onFinish() {
            isLoading = false
        }
        
    }
    
    /// MARK: - Properties
    @StateObject private var imageLoader: Loader
    var placeholder: Content
    var failureImage:  Content
    
    public init(url: String,
                @ViewBuilder placeholder: @escaping () -> Content,
                @ViewBuilder failureImage: @escaping () -> Content) {
        _imageLoader = StateObject(wrappedValue: Loader(url: url, cache: Environment(\.imageCache).wrappedValue))
        self.placeholder = placeholder()
        self.failureImage = failureImage()
    }
    
    public var body: some View {
        selectImage()
            .onAppear(perform: imageLoader.load)
    }
    
    @ViewBuilder private func selectImage() -> some View {
        switch imageLoader.state {
        case .loading:
            placeholder
        case .failure:
            failureImage
        case .success(let image):
            Image(uiImage: image)
                .resizable()
        }
    }
}
