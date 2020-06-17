AudioburstPlayer
============

AudioburstPlayer consists of two modes of audio player (compact and fullscreen) which allows you to:

- download a custom playlist,
- play any burst from the playlist,
- skip to the next or previous burst,
- keep listening,
- move backward and forward within a single burst,
- preview the title, the show name and show cover image,
- play the playlist continuously in a background,
- control the playlist from the locked screen,
- plug the headphones or cast the audio to other devices via bluetooth or air-play,
- see bursts list
- support dark/light theme

## Requirements

- iOS 12.0+
- Xcode 11

## Integration

#### CocoaPods (iOS 8+, OS X 10.9+)

You can use [CocoaPods](http://cocoapods.org/) to install `AudioburstPlayer` by adding it to your `Podfile`:

```ruby
platform :ios, '12.0'
use_frameworks!

target 'MyApp' do
    pod 'AudioburstPlayer', '~> 1.0'
end
```

## Getting started

To start using `AudioburstPlayer`, you need to provide an application key (check [Audioburst Studio site](https://developers.audioburst.com/)) and experienceId that represents customized playlist settings (to obtain one please check [Audioburst Studio site](https://developers.audioburst.com/)).

## Usage

#### Initialization

Correct applicationKey and experienceId are needed to initialize player.

```swift
import AudioburstPlayer
```

```swift
let player = ABPlayer(appKey: applicationKey, experienceId: experienceId)
```


#### Loading player with customized playlist

```swift
player.load() { [weak self] result in
    if case let .success(viewController) = result {
        self.addViewControllerAsChild(viewController, parentView: self.playerViewContainer)
    }
  }
```

#### Error handling

`AudioburstPlayerError` enum is used to represent errors occured in AudioburstPlayer

```swift
player.onError() { [weak self] error in
            self?.showAlert(withTitle: "Error", message: error.localizedDescription)
  }
```

## Dependencies:

Libraries used by AudioburstPlayer (installed as pods dependencies)
- `Alamofire`
- `SwiftGen`
- `IBPCollectionViewCompositionalLayout`
- `Cache`
- `lottie-ios`
- `SDWebImage`
- `OwlKit`


## Demo application
The demo application is a showcase of the AudioburstPlayer. Example application key and experienceId are provided.
