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

<p align="middle">
<img src="https://raw.githubusercontent.com/audioburst-labs/AudioburstPlayer-iOS/master/screenshots/floating_player_1.png?raw=true"  width="180" hspace="5" title="Floating player"/><img src="https://raw.githubusercontent.com/audioburst-labs/AudioburstPlayer-iOS/master/screenshots/floating_player_2.png?raw=true"  width="180" hspace="5" /><img src="https://raw.githubusercontent.com/audioburst-labs/AudioburstPlayer-iOS/master/screenshots/mini_player.png?raw=true"  width="180" hspace="5" /><img src="https://raw.githubusercontent.com/audioburst-labs/AudioburstPlayer-iOS/master/screenshots/fullscreen_player.png?raw=true"  width="180" />
</p>

## Requirements

- iOS 12.0+
- Xcode 11

## Get Started
This guide is a quick walkthrough to add AudioburstPlayer to an iOS app. [AudioburstPlayer](https://cocoapods.org/pods/AudioburstPlayer) can be installed using [CocoaPods](http://cocoapods.org/). The AudioburstPlayerDemo application showcases all features of the AudioburstPlayer. 

## Prerequisites

### Audioburst API key
The library requires an application key which can be obtained via [Audioburst Publishers](https://publishers.audioburst.com/). An experience ID is also available. This is a unique identifier for the customized playlist topics chosen during the setup process.

## Add AudioburstPlayer to your app

### Step 1. Add AudioburstPlayer dependency
You can use [CocoaPods](http://cocoapods.org/) to install [AudioburstPlayer](https://cocoapods.org/pods/AudioburstPlayer) by adding it to your `Podfile`:

```ruby
platform :ios, '12.0'
use_frameworks!

target 'MyApp' do
    pod 'AudioburstPlayer', '~> 0.1.14'
end
```

### Step 2. Init AudioburstPlayer

AudioburstPlayer requires an application key to work. The player can be configured in two ways: via [Audioburst Publishers](https://publishers.audioburst.com/) after obtaining an experience ID or by passing a custom configuration.

```swift
import AudioburstPlayer
```

##### Initialize AudioburstPlayer with application key and experience ID:

```swift
let player = ABPlayer(appKey: "YOUR_APP_KEY", experienceId: "YOUR_EXPERIENCE_ID")
```

##### Initialize AudioburstPlayer with application key and custom configuration:

```swift
let configuration = ABPlayer.Configuration(appKey: "YOUR_APP_KEY",
                                           playerAction: ...,
                                           playerActionValue: ...,
                                           mode: ...,
                                           theme: ...,
                                           accentColor: ...,
                                           autoPlay: ...)
```

```swift
let player = ABPlayer(configuration: configuration)
```

Parameters description:

- applicationKey - String - application key obtained from [Audioburst Publishers](https://publishers.audioburst.com/),
- action - Action enum - one of the types of playlists currently supported by the library,
- actionValue - String - id of playlist that you would like to play,
- mode - Mode enum - mode in which you would like player to appear (Button or Banner),
- theme - Theme enum - theme of the players (Dark or Light),
- accentColor - String - color of accents in players. It needs to be a hex value that starts with `#` character,
- autoPlay - Boolean - whether player should start automatically playing after loading playlist or not.

### Step 3. Loading Audioburst content

Call a method to load Audioburst content in order to get the compact player view controller. Depending on the mode set in Audioburst Publishers, you will get the floating player or mini player view controller. The recommended view container size is: height `100 points`, width: `full screen width` )

```swift
player.load() { [weak self] result in
    if case let .success(viewController) = result {
        self.addViewControllerAsChild(viewController, parentView: self.playerViewContainer)
    }
}
```

After loading content use ` player.openFullscreenPlayer()` to open fullscreen player programmatically. If content is not loaded, calling this method will throw error `AudioburstPlayerError.contentNotReady` in error listener (`AudioburstPlayerErrorListener.onError()`) 

To set container to full screen override method in container UIView (this will allow touches to views below container to pass):

```swift
override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        return hitView == self ? nil : hitView
}
```

You can also use custom class `PassthroughView` provided in the demo application. 

### Step 4. Play content on demand

Request the AudioburstPlayer to start playback at any time using this simple `play()` method:

```swift
player.play()
```

If a playlist has not yet loaded this method call will cause the library to remember the request and playback will automatically start after the loading process is completed.

### Step 5. Handle errors

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

### Step 6. Handle player events
To handle player events make your class implement `AudioburstPlayerListener` protocol, for example:

```swift
extension ViewController: AudioburstPlayerListener {
    func onClose() {
        removeViewControllerAsChild(compactPlayerVC)
    }
}
```
And add listener for player:

```swift
player.add(playerListener: self) 
```

Don’t forget to unregister player listener:

```swift
player.remove(playerListener: self)
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



## Privacy Policy
[Privacy Policy](https://audioburst.com/privacy)

## Terms of Service 
[Terms of Service](https://audioburst.com/audioburst-publisher-terms)

