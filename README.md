# PureSegue

[![Build Status](https://travis-ci.org/ajjnix/PureSegue.svg?branch=master)](https://travis-ci.org/ajjnix/PureSegue)
[![Coverage Status](https://coveralls.io/repos/github/ajjnix/PureSegue/badge.svg)](https://coveralls.io/github/ajjnix/PureSegue)
[![Version](https://img.shields.io/cocoapods/v/PureSegue.svg?style=flat)](http://cocoapods.org/pods/PureSegue)
[![License](https://img.shields.io/cocoapods/l/PureSegue.svg?style=flat)](http://cocoapods.org/pods/PureSegue)
[![Platform](https://img.shields.io/cocoapods/p/PureSegue.svg?style=flat)](http://cocoapods.org/pods/PureSegue)

# PureSegue
**PureSegue** makes usage of `storyboard segue` very simple and allows you to get rid of `prepareForSegue`.
```Swift
prs_performSegue(withIdentifier: "segue_identifier", configurate: { segue in
//segue: UIStoryboardSegue
})
```

If you use `destination` class' name as identificator for `segue`, it will automatically use type casting in `closure`:
```Swift
prs_performSegue(to: MyViewController.self, configurate: { viewController in
//viewController: Optional<MyViewController> 
})
```
Don't worry, usage of **PureSegue** doesn't influence on usage of `prepareForSegue`.


### Install [CocoaPods](http://cocoapods.org)

To install it, simply add the following line to your Podfile:

```ruby
pod 'PureSegue'
```

## Author

Artem Mylnikov (ajjnix), ajjnix@gmail.com

## License

PureSegue is available under the MIT license. See the LICENSE file for more info.
