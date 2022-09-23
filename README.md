# SwiftDropdown

A simple fully customizable dropdown.

[![Swift](https://img.shields.io/badge/Swift-5-orange)](https://img.shields.io/badge/Swift-5-orange)
[![Platforms](https://img.shields.io/badge/Platforms-iOS-yellowgreen)](https://img.shields.io/badge/Platforms-iOS-yellowgreen)
[![Swift Package Manager](https://img.shields.io/badge/SwiftPackageManager-Compatible-brightgreen)](https://img.shields.io/badge/SwiftPackageManager-Compatible-brightgreen)

## Installation

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. 

Once you have your Swift package set up, add SwiftDropdown to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/giuseppebruno/SwiftDropdown.git", .upToNextMajor(from: "1.0.0"))
]
```

## Usage

Add a `UIView` from the Storyboard and subclass as `SwiftDropdown` or create a `SwiftDropdown` view from code.

```swift
import SwiftDropdown

...

let dropdown = SwiftDropdown()
dropdown.placeholderText = "Select..."
dropdown.options = ["Option 1", "Option 2", "Option 3"]
```

#### That's it.

## Customization

You can customize the Dropdown as follow:

#### Dropdown box

- `boxBackgroundColor`: Dropdown box background color. Default: white
- `placeholderFont`: Dropdown box text font. Default: System font
- `placeholderColor`: Dropdown box text color. Default: black
- `arrowImage`: Dropdown arrow image.
- `arrowPosition`: Arrow position. Default: right
- `cornerRadius`: Box and dropdown corner radius
- `borderWidth`: Box and dropdown border width. Default: 1
- `borderColor`: Box and dropdown border color. Default: black
- `disableArrowAnimation`: Disable arrow animation. Default: true

#### Dropdown

- `dropdownHeight`: Dropdown height. By default will be calculated automatically.
- `itemsRowHeight`: Dropdown items row height. Default: 44
- `itemsFont`: Dropdown items text font. Default: System font
- `itemsTextColor`: Dropdown items text color. Default: black
- `disableTapToDismiss`: Disable tap outside the dropdown to dismiss itself. Default: false
- `dropdownExtraSpace`: Space between the box and the dropdown. Default: 8
- `itemsBackgroundColor`: Dropdown items background color. Default: white
- `showSelectedItemCheckmark`: Show checkmark for selected item. Default: true
- `checkmarkColor`: Selected item checkmark color. Default: system blue
- `highlightSelectedItem`: Highlight selected item. Default: false
- `selectedItemBackgroundColor`: Selected item background color. Default: system blue
- `selectedItemTextColor`: Selected item text color. Default: white

#### API

- `selectedIndex`: Current selected index. If setted, the dropdown will show the item as selected.
- `selectedItem`: Current selected item

#### Delegate

```swift
class MyViewController: UIViewController, SwiftDropdownDelegate {

...

dropdown.delegate = self

...

func dropdownItemSelected(index: Int, item: String) {}

```

## Contributing

We welcome all contributions. If you found a bug, feel free to open an issue. If you want to contribute, submit a pull request.

## Show your support 💪

1. ⭐️ Star the repo
2. 🗣 Share the repo with your friends

## Credits

SwiftDropdown is developed by [Giuseppe Bruno](https://github.com/giuseppebruno).

## License

SwiftDropdown is released under the MIT license. See [LICENSE](https://github.com/giuseppebruno/SwiftDropdown/blob/master/LICENSE) for details.
