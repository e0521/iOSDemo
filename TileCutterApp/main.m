//
//  main.m
//  TileCutterApp
//
//  Created by admin on 2021/5/14.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        if (argc < 2) {
            NSLog(@"TileCutter argument: inputfile");
            return 0;
        }
        
        NSString *inputFile = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
        CGFloat tileSize = 256;
        NSString *outputPath = [inputFile stringByDeletingPathExtension];
                
        NSImage *image = [[NSImage alloc] initWithContentsOfFile:inputFile];
        
        NSSize size = [image size];
        NSArray *representations = [image representations];
        
        if ([representations count]) {
            NSBitmapImageRep *representation = representations[0];
            size.width = [representation pixelsWide];
            size.height = [representation pixelsHigh];
        }
        
        NSLog(@"image == %@\n ===%s", image, argv[1]);
        
        NSRect rect = NSMakeRect(0, 0, size.width, size.height);
        CGImageRef imageRef = [image CGImageForProposedRect:&rect context:NULL hints:nil];
        
        NSInteger rows = ceil(size.height/tileSize);
        NSInteger cols = ceil(size.width/tileSize);
        
        NSArray *sizeArr = @[@1024, @180, @167, @152, @120, @87, @80, @76, @60, @58, @40, @29, @20];
//        NSData *imageData = [[NSData alloc] initWithContentsOfFile:inputFile];
//        CFDataRef dataRef = (__bridge CFDataRef)imageData;
                
        for (int i =0 ; i < sizeArr.count; i++) {
            CGFloat width = [[sizeArr objectAtIndex:i] floatValue];
            size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
            size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
            CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
            uint32_t bitmapInfo = CGImageGetBitmapInfo(imageRef);
            CGContextRef context = CGBitmapContextCreate(nil, width, width, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo);
//            CGImageGetAlphaInfo(<#CGImageRef  _Nullable image#>)
            
            CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
            CGContextDrawImage(context, CGRectMake(0, 0, width, width), imageRef);
            
            CGImageRef img = CGBitmapContextCreateImage(context);
            
            NSDictionary *dict;
            NSBitmapImageRep *imageRep = [[NSBitmapImageRep alloc] initWithCGImage:img];
            NSData *data = [imageRep representationUsingType:NSBitmapImageFileTypePNG properties:dict];
            CFRelease(context);
            CFRelease(img);

            NSLog(@"%@==== %@", data, dict);
            
            NSString *path = [outputPath stringByAppendingFormat:@"_%ld.png", (NSInteger)width];
            [data writeToFile:path atomically:false];


        }
//
        
//        for (int y = 0; y < rows; y++) {
//            for (int x = 0; x < cols; x++) {
//                CGRect tileRect = CGRectMake(x*tileSize, y*tileSize, tileSize, tileSize);
//                CGImageRef tileImage = CGImageCreateWithImageInRect(imageRef, tileRect);
//
//                NSBitmapImageRep *imageRep = [[NSBitmapImageRep alloc] initWithCGImage:tileImage];
//                NSDictionary *dict;
//                NSData *data = [imageRep representationUsingType:NSBitmapImageFileTypePNG properties:dict];
//                CGImageRelease(tileImage);
//
//                NSString *path = [outputPath stringByAppendingFormat:@"_%02i_%02i.png", x, y];
//                [data writeToFile:path atomically:false];
//            }
//        }
        
        
    }
    return 0;
}
