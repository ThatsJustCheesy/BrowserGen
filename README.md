Generates single-site web browsers. Suitable for simple reference sites (e.g. [WordReference.com](http://www.wordreference.com/), [OSStatus.com](https://osstatus.com)). May work with other types of sites, such as web applications, but that is not at all recommended, as only barebones web browser functionality is implemented.

Build & run the “BrowserGen” scheme of the xcodeproj, and use the GUI to generate browsers. They are automatically placed in /Applications, taking care not to replace any existing apps. From there you can simply launch the generated apps and use them.

This is not very secure due to what it is (an application generator). Don’t use on public networks, on server machines, etc. The generated apps are set to “allow arbitrary loads” so that HTTP websites work, and they aren’t sandboxed due to my kludgy way of doing custom icons (`codesign` won’t sign anything with xattrs). Your use of this software is entirely at your own risk. IMO, stick to private home networks and trusted websites, keep on top of your security updates, and you should be fine. But again, use at own risk.

I personally use this as follows, YMMV:

1. Generate a single-site browser for a commonly-visited reference site, like the ones above.
2. When I need the reference material, hit ⌘Space for Spotlight Search, and type the site name, which leads to the app. (Quick general Spotlight tip: if you have an app called e.g. WordReference, typing “wr” is sufficient for Spotlight to direct you to it)
3. Type something into the reference site.
4. When done, either ⌘H hide the app or ⌘Q quit it.
5. Repeat from step 2 whenever the material is needed again.

This, in my opinion, is far easier than fumbling into the web browser, opening a new window, and even just clicking on a Favourites icon.  
P.S. I don't use this for word definitions. Another quick Spotlight tip: hold down ⌘L in the search window to jump to the dictionary definition, and optionally press ⌘D to open in Dictionary.app. Also, ⌘B opens a web search in the default browser. Just thought I'd share.

MIT-licensed.

😊 Ian
