# Format Converters

This directory contains the format conversion implementations for ImageOptim Enhanced.

## Architecture

### FormatConverterFactory
The main factory class that routes conversion requests to appropriate converters based on the target format.

### Individual Converters

#### AVIFConverter
- Uses libavif for AVIF encoding
- Supports both RGB and RGBA images
- Configurable quality settings
- Hardware acceleration when available

#### WebPConverter  
- Uses libwebp for WebP encoding
- Supports both lossy and lossless compression
- Alpha channel preservation
- Optimized encoding settings

## Usage

```objc
// Convert to WebP with 85% quality
NSData *webpData = [FormatConverterFactory convertImageData:originalData 
                                                   toFormat:ImageOutputFormatWebP 
                                                    quality:0.85];

// Check if format is supported
BOOL avifSupported = [FormatConverterFactory isFormatSupported:ImageOutputFormatAVIF];

// Get all supported formats
NSArray<NSNumber *> *formats = [FormatConverterFactory supportedFormats];
```

## Adding New Formats

To add support for a new format:

1. Create a new converter class (e.g., `HEIFConverter`)
2. Implement the required methods:
   - `+ (nullable NSData *)convertImageData:quality:`
   - `+ (nullable NSData *)convertBitmapImageRep:quality:`
   - `+ (BOOL)isFormatSupported`
3. Add the format to the `ImageOutputFormat` enum
4. Update `FormatConverterFactory` to route to your converter
5. Update `ImageProcessor` with the new file extension and MIME type

## Dependencies

- **libavif**: For AVIF support (requires manual build)
- **libwebp**: For WebP support (available via CocoaPods)
- **VideoToolbox**: For AVIF hardware acceleration (system framework)

## Performance Considerations

- AVIF encoding is CPU-intensive and may take several seconds for large images
- WebP encoding is generally faster than AVIF but slower than JPEG
- Consider showing progress indicators for long-running conversions
- Hardware acceleration is automatically used when available for AVIF