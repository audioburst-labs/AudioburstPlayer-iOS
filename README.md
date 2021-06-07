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
    pod 'AudioburstPlayer', '~> 0.2.3'
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
                                           mode: ...,
                                           theme: ...,
                                           accentColor: ...,
                                           autoPlay: ...)
```

```swift
let player = ABPlayer(configuration: configuration)
```

Parameters description:

- appKey - String - application key obtained from [Audioburst Publishers](https://publishers.audioburst.com/),
- playerAction - `PlayerAction` enum - one of the types of playlists currently supported by the library,
- mode - `PlayerMode` enum - mode in which you would like player to appear (`button` or `banner`),
- theme - `PlayerTheme` enum - theme of the players (`dark` or `light`),
- accentColor - String - color of accents in players. It needs to be a hex value that starts with `#` character,
- autoPlay - Boolean - whether player should start automatically playing after loading playlist or not.

Possible `playerAction` values:

- channel(category: String)
- userGenerated(id: String)
- sopurce(id: String)
- account(id: String)
- voice(data: Data?)

Most of the options above accepts String as a parameter (`category` or `id`).
`voice` playlist is a special type that accepts byte array from PCM file that should contain a voice saying what user would like to listen about.

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

### Step 5. Pass recorded PCM file

AudioburstPlayer is able to process raw audio files that contain a recorded request of what should be played. You can record a voice command stating what you would like to listen to and then upload it to your device and use AudioburstPlayer to play it.

```swift
func load(voiceData: Data, completion: @escaping (_ result: Result<UIViewController, AudioburstPlayerError>) -> Void)
```

```swift
 player?.load(voiceData: data) { result in
 		//actions after loading voice data playlist
 }
```

The `load` function accepts `Data` as an argument. A request included in the PCM file will be processed and the player will load a playlist of the bursts found. If no bursts are found, `AudioburstPlayerErrorListener` will be called. If player view controller was already created playlist is loaded to current player view controller (and current instance is returned in completion). If player view controller was not created, new instance of view controller with loaded playlist is created and returned in completion. Please remember that before playing any PCM file the SDK must be initialized.

### Step 6. Programatically control Floating (Button) player

When you choose to use Floating (Button) Player you can better control its position and state with the set of the functions described below.

#### `func set(position: CGPoint)`

This function accepts CGPoint with x and y coordinates. It will let you move floating player around and place it wherever you want. If you call this function before  player view controller is loaded  you will make library remember the position and it will show it at requested position as soon as player view controller is added to view hierarchy.

```swift
player.set(position:  CGPoint(x: 100, y: 200))
```

#### `func set(playerState: CompactPlayerState)`

Floating player can be displayed in one of the following states:

- `Floating` - the default state. When it is being shown as a small circle.
- `Expanded` - the state where additional information and playback control buttons are displayed.
- `Sticky` - minimized player that is attached to one of the side edges. It is possible to transit between following states:
- From `Floating` to `Expanded` - it will animate a player expand.
- From `Expanded` to `Floating` - it will animate a player collapse.
- From `Floating` to `Sticky` - it will find the closest edge and attach to it.
- From `Sticky` to `Floating` - it will detach from to edge.

You can control the appearance by using this function:

```swift
player.set(playerState: .sticky)
```

If you call this function before  player is loaded / added to view hierarchy you will make library remember the requested state and it will show in it as soon as player view controller is added to view hierarchy.

#### `func getPlayerStatus() -> CompactPlayerStatus?`

This function will let you know what is the `CompactPlayerStatus`: 

`position: CGPoint` current coordinates of the floating player

`state: CompactPlayerState` current state of the floating player

`lastActivation: Date?`  last time when floating player has been used by the user. It can be null if there was no action performed on the player yet. 

This function can return null when floating player is not shown yet.

### Step 7. Handle errors

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

### Step 8. Handle player events
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

