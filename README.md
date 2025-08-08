# HSBottomSheet

[![CI Status](https://img.shields.io/travis/Himanshu/HSBottomSheet.svg?style=flat)](https://travis-ci.org/Himanshu/HSBottomSheet)
[![Version](https://img.shields.io/cocoapods/v/HSBottomSheet.svg?style=flat)](https://cocoapods.org/pods/HSBottomSheet)
[![License](https://img.shields.io/cocoapods/l/HSBottomSheet.svg?style=flat)](https://cocoapods.org/pods/HSBottomSheet)
[![Platform](https://img.shields.io/cocoapods/p/HSBottomSheet.svg?style=flat)](https://cocoapods.org/pods/HSBottomSheet)

A flexible iOS library for presenting view controllers as bottom sheets and side menus with customizable positioning, sizing, and animations.

## Features

- **Bottom Sheet**: Present view controllers as bottom sheets with customizable edges and corner radius
- **Side Menu**: Present view controllers as side menus with multiple positioning options
- **Flexible Positioning**: Support for left/right positioning and top/center/bottom/full-height alignment
- **Customizable Sizing**: Control the width percentage of side menus (10% to 100% of screen width)
- **Gesture Support**: Swipe to dismiss functionality with configurable thresholds
- **Safe Area Support**: Proper handling of safe areas for all device orientations
- **Customizable UI**: Configurable corner radius, dismiss buttons, and callbacks

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- iOS 9.0+
- Swift 5.0+
- Xcode 12.0+

## Installation

HSBottomSheet is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'HSBottomSheet', :git => "https://github.com/himanshusingh1/HSBottomSheet.git"
```

## Usage

### Bottom Sheet

```swift
import HSBottomSheet

// Basic usage
let viewController = YourViewController()
HSBottomSheet.show(
    masterViewController: viewController,
    cornerRadius: 20,
    canDissmiss: true
)

// Advanced usage with custom configuration
HSBottomSheet.show(
    edges: UIEdgeInsets(top: 22, left: 0, bottom: 0, right: 0),
    masterViewController: viewController,
    cornerRadius: 20,
    canDissmiss: true,
    dismissButtonConfig: { button in
        button.setTitle("✕", for: .normal)
        button.backgroundColor = .systemRed
    },
    didDissMiss: {
        print("Bottom sheet dismissed")
    }
)
```

### Side Menu

```swift
import HSBottomSheet

// Basic left side menu
let viewController = YourViewController()
let config = SideMenuConfiguration(
    position: .left,
    alignment: .fullHeight,
    widthPercentage: 0.8
)
HSBottomSheet.showSideMenu(viewController: viewController, configuration: config)

// Right side menu with custom alignment
let rightConfig = SideMenuConfiguration(
    position: .right,
    alignment: .center,
    widthPercentage: 0.6,
    cornerRadius: 20,
    canDismiss: true,
    dismissButtonConfig: { button in
        button.setTitle("✕", for: .normal)
        button.backgroundColor = .systemRed
    },
    didDismiss: {
        print("Side menu dismissed")
    }
)
HSBottomSheet.showSideMenu(viewController: viewController, configuration: rightConfig)
```

### Side Menu Configuration Options

#### Position
- `.left`: Menu slides in from the left
- `.right`: Menu slides in from the right

#### Alignment
- `.top`: Menu aligns to the top of the screen
- `.center`: Menu centers vertically on the screen
- `.bottom`: Menu aligns to the bottom of the screen
- `.fullHeight`: Menu spans the full height of the screen

#### Width Percentage
- Range: 0.1 to 1.0 (10% to 100% of screen width)
- Default: 0.8 (80% of screen width)

### Dismissing

Both bottom sheets and side menus can be dismissed programmatically:

```swift
// Dismiss specific view controller
HSBottomSheet.dismiss(vc: yourViewController)

// Dismiss side menu specifically
HSBottomSheet.dismissSideMenu(vc: yourViewController)

// Dismiss all presented sheets/menus
HSBottomSheet.dismissAll()
```

### User Interaction

- **Tap outside content**: Side menus can be dismissed by tapping on the background area
- **Swipe gesture**: Swipe left/right to dismiss side menus (configurable threshold)
- **Dismiss button**: Customizable dismiss button positioned outside the menu content

## Author

Himanshu, himanshusingh@hotmail.co.uk

## License

HSBottomSheet is available under the MIT license. See the LICENSE file for more info.
