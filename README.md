# 500px_Challenge
500px Challenge for Mobile Developer Intern (Summer: May to Sep)

I used the 500px iOS SDK for OAuth and Photo HttpRequest. I removed the JSON serialization in PXAPI for easier parsing under Swift 3.

CollectionView scroll vertically in Portrait and horizontally in Landscape.
Photo grid mapping using three columns as default.
Photo can be expand into two columns under certain rules.
Photo grid preseves the image size ratio with minor correction ( ~ 40px ).
The purpose of minor image size correction is to increase the probability of collapse columns and fix narrow image sizes.
You can change the photo expansion probability by changing `doubleCellProbability` in `PhotoWallLayout`.

Clicking the photo thumbnail will allow you to see the large image with some photo detail in fullscreen.
Single click on the image will show/hide the detail and navigation bar.
Double click on the image will change image to AspectFit/AspectFill mode.

[Kingfisher](https://github.com/onevcat/Kingfisher) is used for download and cache images in this App.
