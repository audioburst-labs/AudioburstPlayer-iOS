# AudioburstPlayer iOS SDK

## Introduction

AudioburstPlayer is the SDK for iOS that plays a pre-arranged playlist of audio items - or ‘bursts’ - short snippets of spoken-word audio sourced from live radio and premium podcasts.

## Features

AudioburstPlayer offers two modes: compact and full screen. Both offer the following features:
- Play any burst from the playlist
- Skip to the next or previous burst
- Keep listening (switch to a longer version of the burst)
- Move playhead backward and forward within a single burst
- Displays Burst title and Show name
- Playlist plays continuously in background
- Playlist can be controlled from locked screen
- Play playlist via alternative audio output: headphones, bluetooth devices or AirPlay
- View/scroll bursts in playlists
- Includes support for Dark Mode

## Requirements

- iOS 12.0+
- Xcode 11

## Get Started
This guide is a quick walkthrough to add AudioburstPlayer to an iOS app. [AudioburstPlayer](https://cocoapods.org/pods/AudioburstPlayer) can be installed using [CocoaPods](http://cocoapods.org/). The AudioburstPlayerDemo application showcases all features of the AudioburstPlayer. 

## Prerequisites

### Audioburst API key
The application requires an application key and experience ID, both of which can be obtained via [Audioburst Publishers](https://studio.audioburst.com/). The experience ID is a unique identifier for the customized playlist topics chosen during the setup process in Audioburst Publishers.

## Add AudioburstPlayer to your app

### Step 1. Add AudioburstPlayer dependency
You can use [CocoaPods](http://cocoapods.org/) to install [AudioburstPlayer](https://cocoapods.org/pods/AudioburstPlayer) by adding it to your `Podfile`:

```ruby
platform :ios, '12.0'
use_frameworks!

target 'MyApp' do
    pod 'AudioburstPlayer', '~> 0.1.3'
end
```

### Step 2. Init AudioburstPlayer

A valid application key and experience ID are required to initialize AudioburstPlayer.

```swift
import AudioburstPlayer
```

```swift
let player = ABPlayer(appKey: "YOUR_APP_KEY", experienceId: "YOUR_EXPERIENCE_ID")
```

### Step 3. Start playing Audioburst content
You simply need to call a method to load Compact Player view and begin playing Audioburst content:
```swift
player.load() { [weak self] result in
    if case let .success(viewController) = result {
        self.addViewControllerAsChild(viewController, parentView: self.playerViewContainer)
    }
}
```

### Step 4. Handle errors
`AudioburstPlayerError` enum is used to represent errors that occur in `AudioburstPlayer`. To handle errors make your class implement `AudioburstPlayerErrorListener` protocol, for example:

```swift
extension ViewController: AudioburstPlayerErrorListener {
    func onError(error: AudioburstPlayerError) {
         self.showAlert(withTitle: "Error", message: error.localizedDescription)
    }
}
```
And add listener for player:

```swift
player.add(errorListener: self)
```

Don’t forget to unregister listener:

```swift
player.remove(errorListener: self)
```

## Dependencies
Libraries used by AudioburstPlayer (installed as pods dependencies)

- `Alamofire`
- `SwiftGen`
- `IBPCollectionViewCompositionalLayout`
- `Cache`
- `lottie-ios`
- `SDWebImage`
- `OwlKit`
