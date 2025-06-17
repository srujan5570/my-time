# CastarSDK Framework Structure

When you download and extract the CastarSDK, you should see a structure similar to this:

```
CastarSDK.framework/
├── CastarSDK
├── Headers/
│   ├── Castar.h
│   └── CastarSDK.h
├── Info.plist
├── Modules/
│   └── module.modulemap
└── _CodeSignature/
    └── CodeResources
```

## Key Components

### Headers

The `Headers` directory contains the public headers for the SDK:

- `CastarSDK.h`: The main header file that imports all necessary headers
- `Castar.h`: Contains the Castar class definition and methods

### Main Class: Castar

The main class you'll interact with is `Castar`. It provides the following key methods:

```swift
// Create an instance of Castar with your client ID
static func createInstance(devKey: String) -> Result<Castar, Error>

// Start the SDK
func start()

// Stop the SDK
func stop()
```

## Integration Example

```swift
import CastarSDK

// Create a Castar instance with your client ID
let result = Castar.createInstance(devKey: "YOUR_CLIENT_ID")

switch result {
case .success(let castarInstance):
    // Start the SDK
    castarInstance.start()
    
    // Later, when you want to stop the SDK
    castarInstance.stop()
    
case .failure(let error):
    print("Failed to initialize Castar: \(error.localizedDescription)")
}
``` 