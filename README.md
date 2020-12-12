# UniversalUI

UniversalUI is a Swift library containing various SwiftUI components that can be used in any iOS project.

## Installation
### Swift Package Manager

```
let package = Package(
    dependencies: [
        .package(url: "https://github.com/Luissh22/UniversalUI.git", from: "1.0")
    ],
)
```

## SearchBarView
Native SwiftUI component for a search bar. It's a `TextField` under the hood with styling that makes it look like the native iOS search bar control. 

### Usage
```
// Search bar updates this field
@State private var searchText = ""

let placeholder: LocalizedStringKey = "Search..."

SearchBarView(placeholder: placeholder, text: $searchText)
```

## RefreshableScrollView
SwifUI's `ScrollView` component doesn't provide any ability to add a `UIRefreshControl`. Pulling to refresh is a common pattern in popular iOS apps. This component wraps `UIScrollView` in a SwiftUI view and accepts a callback that runs when the user pulls to refresh.

### Usage
```
RefreshableScrollView(refreshAction: refreshAction) {
    LazyVStack {
        ForEach(...) {
         // some view here
         }
    }
}

func refreshAction() {
    // Refresh data
}
```

## RemoteImage
Image component that retrieves an Image from some URL. Performs this action asynchronously and accepts a placeholder view to show while the image is loading. Also accepts a view to show if it has failed to load. 

### Usage
#### ImageCache
```
// Set environment object
.environment(\.imageCache, TemporaryImageCache(limit: 1)) // if limit is 0, cache doesn't have a limit
```
#### RemoteImage
```
RemoteImage(url: "<remote-url>") {
    Image(systemName: "photo") // Placeholder image
        .resizable()
} failureImage: {
    Image(systemName: "multiply.circle") // Image shown on failure
}
.aspectRatio(contentMode: .fit)
.frame(width: 200)
```

### Usage

## LazyView
Lazily loads a SwiftUI view. Useful for `NavigationLink`s which immediately create the destination view. This essentially delays creating the passed in view until `LazyView` is on screen (when its `body` property is executed rather than its `init`).

### Usage
```
LazyView(Text("This is lazy loaded"))
```


