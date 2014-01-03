MPColorTools
============

A collection of tool for handling colors on iOS SDK.

This tool will add a couple of handy macros for creating colors on the fly, and will also add the capability of working with HSL values instead of just RGB and HSV/HSB.

Since it is more frequent to work with color values in the RGB `(0,255)` range, 
this tool will add a couple of macros that will ease your work of defining colors with 
'natural' values instead of forcing you to convert those values in the `(0.0, 1.0)` range.


Installation
------------

### Manually

Just add to your project the two main files:
  1. MPColorTools.h
  2. MPColorTools.m

### Using [CocoaPods][cocoapods]

[cocoapods]: http://cocoapods.org/

Just add the following line to the `Podfile` in your project:

```ruby
pod "MPColorTools"
```

Usage
-----

### Short-hand macros

You will be able to create colors using RGB values in the (0,255) range:

```objc
UIColor *myColor = MP_RGB(100, 120, 200);
```

And will be able to create them even with a custom alpha value:

```objc
UIColor *myTransparentColor = MP_RGBA(100, 120, 200, 0.2);
```

In case you need to create a gray-scale color, there are a couple of macros for that too:

```objc
UIColor *myGrayColor = MP_GRAY(128);
UIColor *myGrayTransparentColor = MP_GRAYA(128, 0.2);
```

### Hex values support

Like in CSS script files, you can create color starting from string hex values. Values can be defined in these formats:
  1. RGB
  2. RGBA
  3. RRGGBB
  4. RRGGBBAA
  
I.e you can create color like this:

```objc
UIColor *myHexColor = MP_HEX_RGB(@"FCE");   // Will be the equivalent of using @"FFCCEEFF"
UIColor *myHexFullColor = MP_HEX_RGB(@"AAB678CC");
```

If you are using pure integer values for handling colors, you can use this other approach:

```objc
UIColor *myHexIntColor = [UIColor colorWithRGB:0xff443c];
UIColor *myHexIntShortColor = MP_HEX_INT(0xff443c);
UIColor *myHexIntShortTransparentColor = MP_HEX_INTA(0xff443c, 0.2);
```

### Hue/Saturation/Lightness (HSL) support

Since the lack of HSL values support in the iOS SDK, a couple of handy functions have been added:

```objc
UIColor *hslColor = [UIColor colorWithHue:0.1 saturation:0.4 lightness:0.6 alpha:1];
```

or shortly:

```objc
UIColor *hslColor = MP_HSL(0.1, 0.4, 0.6);
```

### CMYK support

The iOS SDK also lacks for the CMYK color space. This tool will make it possibile to create colors in the CMYK color space
and also to get CMYK values from existing colors:

```objc
UIColor *cmykColor = [UIColor colorWithCyan:0.3 magenta:0.9 yellow:1.0 keyBlack:0.1];
UIColor *cmykShortColor = MP_CMYK(0.3,0.9,1.0,0.1);
```

### Lighten and darken colors

You can lighten and darken colors directly using `UIColor`. These two functions will increase or decrease 
lightness by a given percentage:

```objc
UIColor *lighterColor = [myColor colorLightenedBy:0.1];
UIColor *darkerColor = [myColor colorDarkenedBy:0.1];
```

If you want to add or subtract a custom value to the lightness parameter, you can use the following function:

```objc
UIColor *lighterColor = [myColor colorByAddingLightness:0.5];
```

And if you want to generate a new color from the one you already have with a custom lightness values,
ignoring the current one, you can use the following function:


```objc
UIColor *lighterColor = [myColor colorWithLighness:0.7];
UIColor *lighterTransparentColor = [myColor colorWithLighness:0.7 alpha:0.2];
```

### Getters and "setters"

It is fairly difficult to gather a single color space value for a `UIColor` instance. Now you can easily access any value you want
with simple getters:

```objc
UIColor *myColor = MP_RGB(125,125,90);
CGFloat red = myColor.red;
CGFloat light = myColor.lightness;
...
```

`UIColor` are immutable objects, so it's not possible to change color space values on-the-fly. This tool just creates a set of quick
instance methods to duplicate color and change a single color space value on them. It's just as simple as using a setter, with the
only difference that you will create a separate object with the new values:

```objc
UIColor *myColor = MP_GRAY(64);
UIColor *darkRedColor = [myColor colorWithRed:1];
```

Notice that these "setter" methods will accept values in the `[0,1]` range like all the other `UIColor` methods do.

## Copyright

Copyright [2013] Daniele Di Bernardo
                        
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
  
   http://www.apache.org/licenses/LICENSE-2.0
  
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.