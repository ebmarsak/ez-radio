# ez-radio

This is a sample radio streaming application on iOS platform. 

- No third party packages.
- Made using [Radio-Browser](https://www.radio-browser.info/)'s public [API](https://api.radio-browser.info/)
- Basic persistence layer with UserDefaults for recently played stations at "History" screen and for favorite stations at "Favorites" screen.

> Has some bugs when requesting radio stations for countries with a lot of whitespaces in their names. Also UI has an overflow issue when displaying tags at **SearchResultVC** because some of the incoming responses have very long list of tags. Will probably fix this later.  

# GIF Preview

<img src="https://user-images.githubusercontent.com/51510494/156454175-f78ec260-63f6-44f8-9388-cc3dbd5d6ab3.gif" width="405" height="720">

