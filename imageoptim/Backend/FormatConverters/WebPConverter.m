//
//  WebPConverter.m
//  ImageOptim
//
//  Created by Enhanced ImageOptim on 2025.
//
//

#import "WebPConverter.h"
#import "../../log.h"

#ifdef HAVE_LIBWEBP
#import <webp/encode.h>
#import <webp/decode.h>
#endif

@implementation WebPConverter

+ (BOOL)isWebPSupported {
#ifdef HAVE_LIBWEBP
    return YES;
#else
    return NO;
#endif
}

+ (nullable NSData *)convertImageData:(NSData *)imageData quality:(CGFloat)quality {
#ifdef HAVE_LIBWEBP
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
    if (!imageRep) {
        IOWarn("Failed to create bitmap representation for WebP conversion");
        return nil;
    }
    
    return [self convertBitmapImageRep:imageRep quality:quality];
#else
    IOWarn("WebP support not compiled in");
    return nil;
#endif
}

+ (nullable NSData *)convertBitmapImageRep:(NSBitmapImageRep *)imageRep quality:(CGFloat)quality {
#ifdef HAVE_LIBWEBP
    if (!imageRep) {
        return nil;
    }
    
    NSInteger width = imageRep.pixelsWide;
    NSInteger height = imageRep.pixelsHigh;
    
    // Convert to RGB(A) format that libwebp expects
    NSBitmapImageRep *rgbRep = imageRep;
    if (imageRep.colorSpaceName != NSCalibratedRGBColorSpace && 
        imageRep.colorSpaceName != NSDeviceRGBColorSpace) {
        rgbRep = [imageRep bitmapImageRepByConvertingToColorSpace:[NSColorSpace sRGBColorSpace] 
                                                 renderingIntent:NSColorRenderingIntentRelativeColorimetric];
    }
    
    if (!rgbRep) {
        IOWarn("Failed to convert to RGB color space for WebP");
        return nil;
    }
    
    uint8_t *output = NULL;
    size_t output_size = 0;
    
    // Configure WebP encoding
    WebPConfig config;
    if (!WebPConfigInit(&config)) {
        IOWarn("Failed to initialize WebP config");
        return nil;
    }
    
    // Set quality (0-100 scale)
    config.quality = quality * 100;
    config.method = 6; // Higher quality encoding method
    
    if (!WebPValidateConfig(&config)) {
        IOWarn("Invalid WebP configuration");
        return nil;
    }
    
    // Encode based on whether image has alpha
    if (rgbRep.hasAlpha) {
        output_size = WebPEncodeRGBA((uint8_t *)rgbRep.bitmapData,
                                   width, height,
                                   rgbRep.bytesPerRow,
                                   config.quality,
                                   &output);
    } else {
        output_size = WebPEncodeRGB((uint8_t *)rgbRep.bitmapData,
                                  width, height,
                                  rgbRep.bytesPerRow,
                                  config.quality,
                                  &output);
    }
    
    NSData *webpData = nil;
    if (output && output_size > 0) {
        webpData = [NSData dataWithBytes:output length:output_size];
        IODebug("Successfully converted to WebP: %ld bytes", (long)output_size);
    } else {
        IOWarn("Failed to encode WebP image");
    }
    
    // Cleanup
    if (output) {
        WebPFree(output);
    }
    
    return webpData;
#else
    IOWarn("WebP support not compiled in");
    return nil;
#endif
}

@end