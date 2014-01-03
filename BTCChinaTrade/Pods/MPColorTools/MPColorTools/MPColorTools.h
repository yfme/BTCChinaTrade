//
//  MPColorTools.h
//
//  Created by Daniele Di Bernardo on 23/01/13.
//  Copyright (c) 2013 marzapower. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef MP_Color_Tools
#define MP_Color_Tools

#define MP_NUM_MIN(a,b)             (a<b?a:b)
#define MP_NUM_MAX(a,b)             (a>b?a:b)
#define MP_RANGE_0_1(a)             (MP_NUM_MIN(1.0,MP_NUM_MAX(0.0,a)))
#define MP_RANGE_0_255(a)           (MP_NUM_MIN(255,MP_NUM_MAX(0,a)))
#define MP_255_TO_1_SCALE(a)        (MP_RANGE_0_255(a)/255.0)
#define MP_1_TO_255_SCALE(a)        ((int)(MP_RANGE_0_1(a)*255))

#define MP_RGB(r,g,b)               ([UIColor colorWithRed:MP_255_TO_1_SCALE(r) green:MP_255_TO_1_SCALE(g) blue:MP_255_TO_1_SCALE(b) alpha:1])
#define MP_RGBA(r,g,b,a)            ([UIColor colorWithRed:MP_255_TO_1_SCALE(r) green:MP_255_TO_1_SCALE(g) blue:MP_255_TO_1_SCALE(b) alpha:MP_RANGE_0_1(a)])
#define MP_HSL(h,s,l)               ([UIColor colorWithHue:MP_RANGE_0_1(h) saturation:MP_RANGE_0_1(s) lightness:MP_RANGE_0_1(l) alpha:1])
#define MP_HSLA(h,s,l,a)            ([UIColor colorWithHue:MP_RANGE_0_1(h) saturation:MP_RANGE_0_1(s) lightness:MP_RANGE_0_1(l) alpha:MP_RANGE_0_1(a)])
#define MP_HSV(h,s,v)               ([UIColor colorWithHue:MP_RANGE_0_1(h) saturation:MP_RANGE_0_1(s) brightness:MP_RANGE_0_1(v) alpha:1])
#define MP_HSVA(h,s,v,a)            ([UIColor colorWithHue:MP_RANGE_0_1(h) saturation:MP_RANGE_0_1(s) brightness:MP_RANGE_0_1(v) alpha:MP_RANGE_0_1(a)])
#define MP_HSB(h,s,b)               (MP_HSV(h,s,b))
#define MP_HSBA(h,s,b,a)            (MP_HSVA(h,s,b,a))
#define MP_CMYK(c,m,y,k)            ([UIColor colorWithCyan:MP_RANGE_0_1(c) magenta:MP_RANGE_0_1(m) yellow:MP_RANGE_0_1(y) keyBlack:MP_RANGE_0_1(k)])
#define MP_GRAY(g)                  ([UIColor colorWithWhite:MP_255_TO_1_SCALE(g) alpha:1])
#define MP_GRAYA(g,a)               ([UIColor colorWithWhite:MP_255_TO_1_SCALE(g) alpha:MP_RANGE_0_1(a)])

extern UIColor *MP_HEX_RGB(NSString *hexString);
#define MP_HEX_RGB_INT(rgb)         ([UIColor colorWithRGB:(rgb)])
#define MP_HEX_RGB_INTA(rgb,a)      ([UIColor colorWithRGB:(rgb) alpha:MP_RANGE_0_1(a)])

@interface UIColor (MPColorTools)

//=================//
// HSL color space //
//=================//

// Generates a color from HSL values
+ (UIColor *) colorWithHue:(CGFloat)hue saturation:(CGFloat)saturation lightness:(CGFloat)light alpha:(CGFloat)alpha;

// Retrieves HSL values from current color
- (void) getHue:(CGFloat *)hue saturation:(CGFloat *)saturation lightness:(CGFloat *)lightness alpha:(CGFloat *)alpha;


//==================//
// CMYK color space //
//==================//

// Generates a color from CMYK values
+ (UIColor *) colorWithCyan:(CGFloat)cyan magenta:(CGFloat)magenta yellow:(CGFloat)yellow keyBlack:(CGFloat)keyBlack;

// Retrieves CMYK values from current color
- (void) getCyan:(CGFloat *)cyan magenta:(CGFloat *)magenta yellow:(CGFloat *)yellow keyBlack:(CGFloat *)keyBlack;

//===================//
// Utility functions //
//===================//

// Generates a color from a hex rgb value
+ (UIColor *) colorWithRGB:(int32_t)rgbValue;
+ (UIColor *) colorWithRGB:(int32_t)rgbValue alpha:(CGFloat)alpha;

// Lightens a color by a percentage
- (UIColor *) colorLightenedBy:(CGFloat)percent;
// Adds or remove a given amount of lightness to a color
- (UIColor *) colorByAddingLightness:(CGFloat)quantity;
// Darkens a color by a percentage
- (UIColor *) colorDarkenedBy:(CGFloat)percent;

//=====================//
// Getters and setters //
//=====================//

- (CGFloat)red;
- (CGFloat)green;
- (CGFloat)blue;
- (CGFloat)alpha;
- (CGFloat)hue;
- (CGFloat)saturation;
- (CGFloat)brightness;
- (CGFloat)lightness;

- (UIColor *)colorWithRed:(CGFloat)red;
- (UIColor *)colorWithGreen:(CGFloat)green;
- (UIColor *)colorWithBlue:(CGFloat)blue;
- (UIColor *)colorWithHue:(CGFloat)hue;
- (UIColor *)colorWithSaturation:(CGFloat)saturation;
- (UIColor *)colorWithBrightness:(CGFloat)brightness;
- (UIColor *)colorWithLightness:(CGFloat)lightness;
- (UIColor *)colorWithLightness:(CGFloat)lightness alpha:(CGFloat)alpha;

@end

#endif