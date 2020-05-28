# BrowserGen

## Generate single-purpose reference site browsers

_BrowserGen_ is a basic macOS app that generates single-site web browsers, suitable for simple reference sites like [Power Thesaurus](https://www.powerthesaurus.org), [OSStatus.com](https://osstatus.com), and [WordReference](http://www.wordreference.com/) (all highly recommended). The browsers have only barebones functionality, and as such should only be used for relatively simple reference sites.

## Install

For now, you'll have to build and run the "BrowserGen" scheme in the `xcodeproj`.

## Use

Use the GUI in `BrowserGen.app` to generate browsers. They are automatically placed in `/Applications`, taking care not to overwrite existing files; e.g., for the site name `PowerThesaurus`, BrowserGen generates `PowerThesaurus.app`. From there you can launch the generated browser apps and use them.

Here is my typical workflow for accessing reference material using a generated browser:

1. Hit <kbd>⌘Space</kbd> for Spotlight Search, and type the site name, which leads to the app. (You can just type the capital letters, and Spotlight will know what you mean.)
2. Look something up on the reference site.
3. Dismiss the app in some way: <kbd>⌘⇥</kbd> to cycle away, <kbd>⌘H</kbd> to hide, <kbd>⌘Q</kbd> to quit, use Mission Control, etc.

In general, this is far easier than fumbling into a full, general-purpose web browser and navigating to the site, all while fighting the annoying per-application window system in macOS.

## Disclaimer

- The generated browsers are not sandboxed.
- They are not always codesigned.
- They allow communication through HTTP.
- This all sounds like a bad idea, and to be frank, it probably is.
- **Please: only use with trusted websites on trusted networks, and stay on top of security updates.**
- Your use of this software is ultimately at your own risk; there is no warranty provided.

## Other useful Spotlight tricks

- Hold <kbd>⌘L</kbd> to jump to the Dictionary result.
- Press <kbd>⌘D</kbd> to move the search to Dictionary.app.
- Press <kbd>⌘B</kbd> to move the search to the default Safari search engine in the default web browser.

## License

Available under the terms of the [MIT license](LICENSE.txt).
