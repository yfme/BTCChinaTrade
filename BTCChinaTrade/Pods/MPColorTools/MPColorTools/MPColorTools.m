//
//  MPColorTools.m
//
//  Created by Daniele Di Bernardo on 23/01/13.
//  Copyright (c) 2013 marzapower. All rights reserved.
//

#include "MPColorTools.h"

UIColor *MP_HEX_RGB(NSString *hexString) {
  assert(!(nil == hexString || [@"" isEqualToString:hexString]));
  assert(hexString.length == 3 || hexString.length == 4 || hexString.length == 6 || hexString.length == 8);
  
  NSScanner *scanner = nil;//[NSScanner scannerWithString:hexString];
  NSRange range = {0, 1};
  if (hexString.length > 4) {
    range.length = 2;
  }
  
  [scanner setScanLocation:0];
  
  float alpha = range.length == 1 ? 0xF : 0xFF;
  unsigned red = 0;
  unsigned green = 0;
  unsigned blue = 0;
  
  // Red
  scanner = [NSScanner scannerWithString:[hexString substringWithRange:range]];
  [scanner scanHexInt:&red];
  
  // Green
  range.location += range.length;
  scanner = [NSScanner scannerWithString:[hexString substringWithRange:range]];
  [scanner scanHexInt:&green];
  
  // Red
  range.location += range.length;
  scanner = [NSScanner scannerWithString:[hexString substringWithRange:range]];
  [scanner scanHexInt:&blue];
  
  if (hexString.length == 4 || hexString.length == 8) {
    unsigned temp = 0;
    range.location += range.length;
    scanner = [NSScanner scannerWithString:[hexString substringWithRange:range]];
    [scanner scanHexInt:&temp];
    alpha = temp;
  }
  
  if (hexString.length <= 4) {
    red |= red << 4;
    green |= green << 4;
    blue |= blue << 4;
    alpha = (int)alpha | ((int)alpha << 4);
  }
  
  alpha /= 255.0;
  
  return MP_RGBA(red, green, blue, alpha);
}

static void MP_HSL2RGB(float h, float s, float l, float* outR, float* outG, float* outB) {
  float temp1, temp2, temp[3];
  int i;
  
  // Check for saturation. If there isn't any just return the luminance value for each, which results in gray.
  if (s == 0.0) {
    if(outR)
      *outR = l;
    if(outG)
      *outG = l;
    if(outB)
      *outB = l;
    return;
  }
  
  // Test for luminance and compute temporary values based on luminance and saturation
  if (l < 0.5)
    temp2 = l * (1.0 + s);
  else
    temp2 = l + s - l * s;
  temp1 = 2.0 * l - temp2;
  
  // Compute intermediate values based on hue
  temp[0] = h + 1.0 / 3.0;
  temp[1] = h;
  temp[2] = h - 1.0 / 3.0;
  
  for (i = 0; i < 3; ++i) {
    
    // Adjust the range
    if (temp[i] < 0.0)
      temp[i] += 1.0;
    if (temp[i] > 1.0)
      temp[i] -= 1.0;
    
    
    if (6.0 * temp[i] < 1.0)
      temp[i] = temp1 + (temp2 - temp1) * 6.0 * temp[i];
    else {
      if(2.0 * temp[i] < 1.0)
        temp[i] = temp2;
      else {
        if(3.0 * temp[i] < 2.0)
          temp[i] = temp1 + (temp2 - temp1) * ((2.0 / 3.0) - temp[i]) * 6.0;
        else
          temp[i] = temp1;
      }
    }
  }
  
  // Assign temporary values to R, G, B
  if (outR)
    *outR = temp[0];
  if (outG)
    *outG = temp[1];
  if (outB)
    *outB = temp[2];
}


static void MP_RGB2HSL(float r, float g, float b, float* outH, float* outS, float* outL) {
  float h,s, l, v, m, vm, r2, g2, b2;
  
  h = 0;
  s = 0;
  l = 0;
  
  v = MAX(r, g);
  v = MAX(v, b);
  m = MIN(r, g);
  m = MIN(m, b);
  
  l = (m+v)/2.0f;
  
  if (l <= 0.0){
    if(outH)
      *outH = h;
    if(outS)
      *outS = s;
    if(outL)
      *outL = l;
    return;
  }
  
  vm = v - m;
  s = vm;
  
  if (s > 0.0f){
    s/= (l <= 0.5f) ? (v + m) : (2.0 - v - m);
  } else {
    if (outH)
      *outH = h;
    if (outS)
      *outS = s;
    if (outL)
      *outL = l;
    return;
  }
  
  r2 = (v - r)/vm;
  g2 = (v - g)/vm;
  b2 = (v - b)/vm;
  
  if (r == v) {
    h = (g == m ? 5.0f + b2 : 1.0f - g2);
  } else if (g == v) {
    h = (b == m ? 1.0f + r2 : 3.0 - b2);
  } else {
    h = (r == m ? 3.0f + g2 : 5.0f - r2);
  }
  
  h/=6.0f;
  
  if (outH)
    *outH = h;
  if (outS)
    *outS = s;
  if (outL)
    *outL = l;
}

static void MP_RGB2CMYK(float r, float g, float b, float *c, float *m, float *y, float *k) {
  if (r == 0 && g == 0 && b == 0) { // Pure black
    *c = 0; *m = 0; *y = 0; *k = 1;
    return;
  }
  
  *c = 1-r;
  *m = 1-g;
  *y = 1-b;
  float min = MP_NUM_MIN(MP_NUM_MIN(*c,*m),*y);
  *c = (*c-min)/(1-min);
  *m = (*m-min)/(1-min);
  *y = (*y-min)/(1-min);
  *k = min;
}

@implementation UIColor (MPColorTools)

- (void) getHue:(CGFloat *)hue saturation:(CGFloat *)saturation lightness:(CGFloat *)lightness alpha:(CGFloat *)alpha {
  float r = 0;
  float g = 0;
  float b = 0;
  [self getRed:&r green:&g blue:&b alpha:alpha];
  MP_RGB2HSL(r, g, b, hue, saturation, lightness);
}

+ (UIColor *) colorWithHue:(CGFloat)hue saturation:(CGFloat)saturation lightness:(CGFloat)light alpha:(CGFloat)alpha {
  float r = 0;
  float g = 0;
  float b = 0;
  MP_HSL2RGB(hue, saturation, light, &r, &g, &b);
  return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}

- (void) getCyan:(CGFloat *)cyan magenta:(CGFloat *)magenta yellow:(CGFloat *)yellow keyBlack:(CGFloat *)keyBlack {
  float r = 0;
  float g = 0;
  float b = 0;
  [self getRed:&r green:&g blue:&b alpha:nil];
  MP_RGB2CMYK(r,g,b,cyan,magenta,yellow,keyBlack);
}

+ (UIColor *) colorWithCyan:(CGFloat)cyan magenta:(CGFloat)magenta yellow:(CGFloat)yellow keyBlack:(CGFloat)keyBlack {
  int r = MP_1_TO_255_SCALE((1-MP_RANGE_0_1(cyan))*(1-MP_RANGE_0_1(keyBlack)));
  int g = MP_1_TO_255_SCALE((1-MP_RANGE_0_1(magenta))*(1-MP_RANGE_0_1(keyBlack)));
  int b = MP_1_TO_255_SCALE((1-MP_RANGE_0_1(yellow))*(1-MP_RANGE_0_1(keyBlack)));
  return MP_RGB(r,g,b);
}

+ (UIColor *) colorWithRGB:(int32_t)rgbValue {
  return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
                         green:((float)((rgbValue & 0xFF00) >> 8))/255.0
                          blue:((float)(rgbValue & 0xFF))/255.0
                         alpha:1.0];
}

+ (UIColor *) colorWithRGB:(int32_t)rgbValue alpha:(CGFloat)alpha {
  return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
                         green:((float)((rgbValue & 0xFF00) >> 8))/255.0
                          blue:((float)(rgbValue & 0xFF))/255.0
                         alpha:alpha];
}

- (UIColor *) colorByAddingLightness:(CGFloat)quantity {
  CGFloat hue = 0;
  CGFloat sat = 0;
  CGFloat lum = 0;
  CGFloat alp = 0;
  
  [self getHue:&hue saturation:&sat lightness:&lum alpha:&alp];
  lum = MP_RANGE_0_1(lum + quantity);
  
  return [UIColor colorWithHue:hue saturation:sat lightness:lum alpha:alp];
}

- (UIColor *)colorLightenedBy:(CGFloat)percent {
  CGFloat hue = 0;
  CGFloat sat = 0;
  CGFloat lum = 0;
  CGFloat alp = 0;
  
  [self getHue:&hue saturation:&sat lightness:&lum alpha:&alp];
  lum = MP_RANGE_0_1(lum * (1+percent));
  
  return [UIColor colorWithHue:hue saturation:sat lightness:lum alpha:alp];
}

- (UIColor *)colorDarkenedBy:(CGFloat)percent {
  CGFloat hue = 0;
  CGFloat sat = 0;
  CGFloat lum = 0;
  CGFloat alp = 0;
  
  [self getHue:&hue saturation:&sat lightness:&lum alpha:&alp];
  lum = MP_RANGE_0_1(lum * (1-percent));
  
  return [UIColor colorWithHue:hue saturation:sat lightness:lum alpha:alp];
}

- (CGFloat)red {
  return CGColorGetComponents(self.CGColor)[0];
}
- (CGFloat)green {
  return CGColorGetComponents(self.CGColor)[1];
}
- (CGFloat)blue {
  return CGColorGetComponents(self.CGColor)[2];
}
- (CGFloat)alpha {
  return CGColorGetAlpha(self.CGColor);
}
- (CGFloat)hue {
  CGFloat hue, sat, lum, alpha = 0;
  [self getHue:&hue saturation:&sat lightness:&lum alpha:&alpha];
  return hue;
  
}
- (CGFloat)saturation {
  CGFloat hue, sat, bright, alpha = 0;
  [self getHue:&hue saturation:&sat brightness:&bright alpha:&alpha];
  return sat;
}
- (CGFloat)brightness {
  CGFloat hue, sat, bright, alpha = 0;
  [self getHue:&hue saturation:&sat brightness:&bright alpha:&alpha];
  return bright;
}
- (CGFloat)lightness {
  CGFloat hue, sat, lum, alpha = 0;
  [self getHue:&hue saturation:&sat lightness:&lum alpha:&alpha];
  return lum;
}

- (UIColor *)colorWithRed:(CGFloat)_red {
  CGFloat red, green, blue, alpha = 0;
  [self getRed:&red green:&green blue:&blue alpha:&alpha];
  return [UIColor colorWithRed:_red green:green blue:blue alpha:alpha];
}
- (UIColor *)colorWithGreen:(CGFloat)_green {
  CGFloat red, green, blue, alpha = 0;
  [self getRed:&red green:&green blue:&blue alpha:&alpha];
  return [UIColor colorWithRed:red green:_green blue:blue alpha:alpha];
}
- (UIColor *)colorWithBlue:(CGFloat)_blue {
  CGFloat red, green, blue, alpha = 0;
  [self getRed:&red green:&green blue:&blue alpha:&alpha];
  return [UIColor colorWithRed:red green:green blue:_blue alpha:alpha];
}
- (UIColor *)colorWithHue:(CGFloat)hue {
  CGFloat _hue, sat, bright, alpha = 0;
  [self getHue:&_hue saturation:&sat brightness:&bright alpha:&alpha];
  return [UIColor colorWithHue:hue saturation:sat brightness:bright alpha:alpha];
}
- (UIColor *)colorWithSaturation:(CGFloat)saturation {
  CGFloat hue, sat, light, alpha = 0;
  [self getHue:&hue saturation:&sat lightness:&light alpha:&alpha];
  return [UIColor colorWithHue:hue saturation:saturation lightness:light alpha:alpha];
}
- (UIColor *)colorWithBrightness:(CGFloat)brightness {
  CGFloat hue, sat, bright, alpha = 0;
  [self getHue:&hue saturation:&sat brightness:&bright alpha:&alpha];
  return [UIColor colorWithHue:hue saturation:sat brightness:brightness alpha:alpha];
}
- (UIColor *)colorWithLightness:(CGFloat)lightness {
  CGFloat hue, sat, lum, alpha = 0;
  [self getHue:&hue saturation:&sat lightness:&lum alpha:&alpha];
  return [UIColor colorWithHue:hue saturation:sat lightness:lightness alpha:alpha];
}
- (UIColor *)colorWithLightness:(CGFloat)lightness alpha:(CGFloat)alpha {
  CGFloat hue, sat, lum, _alpha = 0;
  [self getHue:&hue saturation:&sat lightness:&lum alpha:&_alpha];
  return [UIColor colorWithHue:hue saturation:sat lightness:lightness alpha:alpha];
}

@end