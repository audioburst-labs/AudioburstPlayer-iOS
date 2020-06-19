# AudioburstPlayer iOS SDK

## Introduction

AudioburstPlayer is the SDK for iOS that will let you play your previously prepared playlist of bursts.

## Features

AudioburstPlayer consists of two modes of audio player - compact and fullscreen which allows you to:
- download a custom playlist,
- play any burst from the playlist,
- skip to the next or previous burst,
- switch to original listening,
- move backward and forward within a single burst,
- preview the title, the show name,
- play the playlist continuously in a background,
- control the playlist from the locked screen,
- plug the headphones or cast the audio to other devices via bluetooth or air-play,
- see bursts list,
- support dark/light theme.

## Requirements

- iOS 12.0+
- Xcode 11

## Get Started

This guide is a quick start to add AudioburstPlayer to an iOS app. You can use [CocoaPods](http://cocoapods.org/) to install [AudioburstPlayer](https://cocoapods.org/pods/AudioburstPlayer). The AudioburstPlayerDemo application is a showcase of the AudioburstPlayer.


## Prerequisites

### Audioburst API key
Your application needs an **application key** (check [Audioburst Studio site](https://studio.audioburst.com/) to obtain the key).
Also you need to provide **experience id** that represents customized playlist settings (check [Audioburst Studio site](https://studio.audioburst.com/) to obtain the id)

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

Valid **application key** and **experience id** are needed to initialize player.

```swift
import AudioburstPlayer
```

```swift
let player = ABPlayer(appKey: "YOUR_APP_KEY", experienceId: "YOUR_EXPERIENCE_ID")
```

### Step 3. Start playing Audioburst content
You simply need to call one method to load Compact Player view and start playing Audioburst content:
```swift
player.load() { [weak self] result in
    if case let .success(viewController) = result {
        self.addViewControllerAsChild(viewController, parentView: self.playerViewContainer)
    }
}
```

### Step 4. Handle errors
`AudioburstPlayerError` enum is used to represent errors occured in AudioburstPlayer

```swift
player.onError() { [weak self] error in
            self?.showAlert(withTitle: "Error", message: error.localizedDescription)
}
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
