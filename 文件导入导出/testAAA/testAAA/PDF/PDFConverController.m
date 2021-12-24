//
//  PDFConverController.m
//  testAAA
//
//  Created by xj_mac on 2021/12/7.
//

#import "PDFConverController.h"
#import <PDFKit/PDFKit.h>
//#import <PSPDF>
@interface PDFConverController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation PDFConverController

- (void)viewDidLoad {
    [super viewDidLoad];
//    CGPDFDictionaryGetStream(<#CGPDFDictionaryRef  _Nullable dict#>, <#const char * _Nonnull key#>, <#CGPDFStreamRef  _Nullable * _Nullable value#>)
    
//    CGPDFDictionaryGetDictionary(<#CGPDFDictionaryRef  _Nullable dict#>, <#const char * _Nonnull key#>, <#CGPDFDictionaryRef  _Nullable * _Nullable value#>)
    
    
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *pdfPath = [[NSBundle mainBundle]pathForResource:@"test" ofType:@"pdf"];
        NSURL *url = [NSURL fileURLWithPath:pdfPath];
        PDFDocument *pdf = [[PDFDocument alloc]initWithURL:url];
        NSInteger pageCount = pdf.pageCount;
        
        NSMutableString *mutable = [NSMutableString new];
        
        //kPDFDisplayBoxMediaBox
        PDFPage *page = [pdf pageAtIndex:40];
//        page
//        NSLog(@"%@",page.annotations);
        UIImage *image = [page thumbnailOfSize:CGSizeMake(800, 800) forBox:kPDFDisplayBoxMediaBox];
        NSLog(@"%@",image);
        //CGPDFDocumentRef
        NSLog(@"%@",page.document.documentRef);
        self.imageView.image = image;
        
//        for (int i = 0; i < pageCount; i++) {
//            PDFPage *page = [pdf pageAtIndex:i];
//            NSString *string = [page.attributedString.string stringByReplacingOccurrencesOfString:@" "withString:@""];//去除中间空格
//            NSArray *lines=[string componentsSeparatedByString:@"\n"];
//
//            for (NSString *str in lines) {
//                if(str.length > 0){
//                    if(![self validatePage:str]){
//                        if ([self validateChapter:str]) { // 是否是章节
//                            NSString *chapter = [NSString stringWithFormat:@"### %@\n",str];
//                            [mutable appendString:chapter];
//                        }else {
//                            NSString *string1 = [NSString stringWithFormat:@"&emsp;&emsp;%@",str];
//                            if ([self validatefuhao:str]) {
//                                [mutable appendString:[NSString stringWithFormat:@"%@\n",string1]];
//                            }else {
//                                [mutable appendString:[NSString stringWithFormat:@"%@",string1]];
//                            }
//
//                        }
//                    }
//                }
//            }
//            NSLog(@"加载中");
//        }
//        NSError *error = nil;
//        NSString *path = [NSString stringWithFormat:@"%@/Documents/test.md",NSHomeDirectory()];
//        [mutable writeToURL:[NSURL fileURLWithPath:path] atomically:YES encoding:NSUTF8StringEncoding error:&error];
//        if (error) {
//            NSLog(@"失败%@",error);
//        }
        NSLog(@"%@",@"完成");
    });
}

/// 创建markdown文件
- (void)createMarkDown {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *pdfPath = [[NSBundle mainBundle]pathForResource:@"test" ofType:@"pdf"];
        NSURL *url = [NSURL fileURLWithPath:pdfPath];
        PDFDocument *pdf = [[PDFDocument alloc]initWithURL:url];
        NSInteger pageCount = pdf.pageCount;
        
        NSMutableString *mutable = [NSMutableString new];
        
        for (int i = 0; i < pageCount; i++) {
            PDFPage *page = [pdf pageAtIndex:i];
            NSString *string = [page.attributedString.string stringByReplacingOccurrencesOfString:@" "withString:@""];//去除中间空格
            NSArray *lines=[string componentsSeparatedByString:@"\n"];
            
            for (NSString *str in lines) {
                if(str.length > 0){
                    if(![self validatePage:str]){
                        if ([self validateChapter:str]) { // 是否是章节
                            NSString *chapter = [NSString stringWithFormat:@"### %@\n",str];
                            [mutable appendString:chapter];
                        }else {
                            NSString *string1 = [NSString stringWithFormat:@"&emsp;&emsp;%@",str];
                            if ([self validatefuhao:str]) {
                                [mutable appendString:[NSString stringWithFormat:@"%@\n",string1]];
                            }else {
                                [mutable appendString:[NSString stringWithFormat:@"%@",string1]];
                            }
                            
                        }
                    }
                }
            }
            NSLog(@"加载中");
        }
        NSError *error = nil;
        NSString *path = [NSString stringWithFormat:@"%@/Documents/test.md",NSHomeDirectory()];
        [mutable writeToURL:[NSURL fileURLWithPath:path] atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"失败%@",error);
        }
        NSLog(@"%@",@"完成");
    });
}

//检测章节
- (BOOL)validateChapter:(NSString *) textString
{
    NSString* number=@"[第].*?[章].*?";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:textString];
}

// 检测页
- (BOOL)validatePage:(NSString *) textString{
    NSString* number=@"[第].*?[页]";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:textString];
}

// 检测符号
- (BOOL)validatefuhao:(NSString *) textString{
    NSString* number=@".*?[。:]";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:textString];
}

//。



NSMutableArray *aRefImgs;
void setRefImgs(NSMutableArray *ref){
    aRefImgs=ref;
}

NSMutableArray* ImgArrRef(){
    return aRefImgs;
}

CGPDFDocumentRef MyGetPDFDocumentRef (const char *filename) {
    CFStringRef path;
    CFURLRef url;
    CGPDFDocumentRef document;
    path = CFStringCreateWithCString (NULL, filename,kCFStringEncodingUTF8);
    url = CFURLCreateWithFileSystemPath (NULL, path, kCFURLPOSIXPathStyle, 0);
    CFRelease (path);
    document = CGPDFDocumentCreateWithURL (url);// 2
    CFRelease(url);
    int count = CGPDFDocumentGetNumberOfPages (document);// 3
    if (count == 0) {
        printf("`%s' needs at least one page!", filename);
        return NULL;
    }
    return document;
}


CGFloat *decodeValuesFromImageDictionary(CGPDFDictionaryRef dict, CGColorSpaceRef cgColorSpace, NSInteger bitsPerComponent) {
    CGFloat *decodeValues = NULL;
    CGPDFArrayRef decodeArray = NULL;

    if (CGPDFDictionaryGetArray(dict, "Decode", &decodeArray)) {
        size_t count = CGPDFArrayGetCount(decodeArray);
        decodeValues = malloc(sizeof(CGFloat) * count);
        CGPDFReal realValue;
        int i;
        for (i = 0; i < count; i++) {
            CGPDFArrayGetNumber(decodeArray, i, &realValue);
            decodeValues[i] = realValue;
        }
    } else {
        size_t n;
        switch (CGColorSpaceGetModel(cgColorSpace)) {
            case kCGColorSpaceModelMonochrome:
                decodeValues = malloc(sizeof(CGFloat) * 2);
                decodeValues[0] = 0.0;
                decodeValues[1] = 1.0;
                break;
            case kCGColorSpaceModelRGB:
                decodeValues = malloc(sizeof(CGFloat) * 6);
                for (int i = 0; i < 6; i++) {
                    decodeValues[i] = i % 2 == 0 ? 0 : 1;
                }
                break;
            case kCGColorSpaceModelCMYK:
                decodeValues = malloc(sizeof(CGFloat) * 8);
                for (int i = 0; i < 8; i++) {
                    decodeValues[i] = i % 2 == 0 ? 0.0 :
                    1.0;
                }
                break;
            case kCGColorSpaceModelLab:
                // ????
                break;
            case kCGColorSpaceModelDeviceN:
                n =
                CGColorSpaceGetNumberOfComponents(cgColorSpace) * 2;
                decodeValues = malloc(sizeof(CGFloat) * (n *
                                                         2));
                for (int i = 0; i < n; i++) {
                    decodeValues[i] = i % 2 == 0 ? 0.0 :
                    1.0;
                }
                break;
            case kCGColorSpaceModelIndexed:
                decodeValues = malloc(sizeof(CGFloat) * 2);
                decodeValues[0] = 0.0;
                decodeValues[1] = pow(2.0,
                                      (double)bitsPerComponent) - 1;
                break;
            default:
                break;
        }
    }
    return decodeValues;
//    return (CGFloat *)CFMakeCollectable(decodeValues);
}

UIImage *getImageRef(CGPDFStreamRef myStream) {
    CGPDFArrayRef colorSpaceArray = NULL;
    CGPDFStreamRef dataStream;
    CGPDFDataFormat format;
    CGPDFDictionaryRef dict;
    CGPDFInteger width, height, bps, spp;
    CGPDFBoolean interpolation = 0;
    //  NSString *colorSpace = nil;
    CGColorSpaceRef cgColorSpace;
    const char *name = NULL, *colorSpaceName = NULL, *renderingIntentName = NULL;
    CFDataRef imageDataPtr = NULL;
    CGImageRef cgImage;
    //maskImage = NULL,
    CGImageRef sourceImage = NULL;
    CGDataProviderRef dataProvider;
    CGColorRenderingIntent renderingIntent;
    CGFloat *decodeValues = NULL;
    UIImage *image;

    if (myStream == NULL)
        return nil;

    dataStream = myStream;
    dict = CGPDFStreamGetDictionary(dataStream);

    // obtain the basic image information
    if (!CGPDFDictionaryGetName(dict, "Subtype", &name))
        return nil;

    if (strcmp(name, "Image") != 0)
        return nil;

    if (!CGPDFDictionaryGetInteger(dict, "Width", &width))
        return nil;

    if (!CGPDFDictionaryGetInteger(dict, "Height", &height))
        return nil;

    if (!CGPDFDictionaryGetInteger(dict, "BitsPerComponent", &bps))
        return nil;

    if (!CGPDFDictionaryGetBoolean(dict, "Interpolate", &interpolation))
        interpolation = NO;

    if (!CGPDFDictionaryGetName(dict, "Intent", &renderingIntentName))
        renderingIntent = kCGRenderingIntentDefault;
    else{
        renderingIntent = kCGRenderingIntentDefault;
        //      renderingIntent = renderingIntentFromName(renderingIntentName);
    }

    imageDataPtr = CGPDFStreamCopyData(dataStream, &format);
    dataProvider = CGDataProviderCreateWithCFData(imageDataPtr);
    CFRelease(imageDataPtr);

    if (CGPDFDictionaryGetArray(dict, "ColorSpace", &colorSpaceArray)) {
        cgColorSpace = CGColorSpaceCreateDeviceRGB();
        //      cgColorSpace = colorSpaceFromPDFArray(colorSpaceArray);
        spp = CGColorSpaceGetNumberOfComponents(cgColorSpace);
    } else if (CGPDFDictionaryGetName(dict, "ColorSpace", &colorSpaceName)) {
        if (strcmp(colorSpaceName, "DeviceRGB") == 0) {
            cgColorSpace = CGColorSpaceCreateDeviceRGB();
            //          CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
            spp = 3;
        } else if (strcmp(colorSpaceName, "DeviceCMYK") == 0) {
            cgColorSpace = CGColorSpaceCreateDeviceCMYK();
            //          CGColorSpaceCreateWithName(kCGColorSpaceGenericCMYK);
            spp = 4;
        } else if (strcmp(colorSpaceName, "DeviceGray") == 0) {
            cgColorSpace = CGColorSpaceCreateDeviceGray();
            //          CGColorSpaceCreateWithName(kCGColorSpaceGenericGray);
            spp = 1;
        } else if (bps == 1) { // if there's no colorspace entry, there's still one we can infer from bps
            cgColorSpace = CGColorSpaceCreateDeviceGray();
            //          colorSpace = NSDeviceBlackColorSpace;
            spp = 1;
        }
    }

    decodeValues = decodeValuesFromImageDictionary(dict, cgColorSpace, bps);

    int rowBits = bps * spp * width;
    int rowBytes = rowBits / 8;
    // pdf image row lengths are padded to byte-alignment
    if (rowBits % 8 != 0)
        ++rowBytes;

//  maskImage = SMaskImageFromImageDictionary(dict);
    
    if (format == CGPDFDataFormatRaw)
    {
        sourceImage = CGImageCreate(width, height, bps, bps * spp, rowBytes, cgColorSpace, 0, dataProvider, decodeValues, interpolation, renderingIntent);
        CGDataProviderRelease(dataProvider);
        cgImage = sourceImage;
//      if (maskImage != NULL) {
//          cgImage = CGImageCreateWithMask(sourceImage, maskImage);
//          CGImageRelease(sourceImage);
//          CGImageRelease(maskImage);
//      } else {
//          cgImage = sourceImage;
//      }
    } else {
        if (format == CGPDFDataFormatJPEGEncoded){ // JPEG data requires a CGImage; AppKit can't decode it {
            sourceImage =
            CGImageCreateWithJPEGDataProvider(dataProvider,decodeValues,interpolation,renderingIntent);
            CGDataProviderRelease(dataProvider);
            cgImage = sourceImage;
//          if (maskImage != NULL) {
//              cgImage = CGImageCreateWithMask(sourceImage,maskImage);
//              CGImageRelease(sourceImage);
//              CGImageRelease(maskImage);
//          } else {
//              cgImage = sourceImage;
//          }
        }
        // note that we could have handled JPEG with ImageIO as well
        else if (format == CGPDFDataFormatJPEG2000) { // JPEG2000 requires ImageIO {
            CFDictionaryRef dictionary = CFDictionaryCreate(NULL, NULL, NULL, 0, NULL, NULL);
            sourceImage=
            CGImageCreateWithJPEGDataProvider(dataProvider, decodeValues, interpolation, renderingIntent);


            //          CGImageSourceRef cgImageSource = CGImageSourceCreateWithDataProvider(dataProvider, dictionary);
            CGDataProviderRelease(dataProvider);

            cgImage=sourceImage;

            //          cgImage = CGImageSourceCreateImageAtIndex(cgImageSource, 0, dictionary);
            CFRelease(dictionary);
        } else // some format we don't know about or an error in the PDF
            return nil;
    }
    image=[UIImage imageWithCGImage:cgImage];
    return image;
}

//-(void)aaaaaaaa{
////    if(arrImgs!=nil && [arrImgs retainCount]>0 ) { [arrImgs release]; arrImgs=nil; }
////    arrImgs=[[NSMutableArray alloc] init];
////
////    setRefImgs(arrImgs);
////  if(nxtTxtDtlVCtr!=nil && [nxtTxtDtlVCtr retainCount]>0) { [nxtTxtDtlVCtr release]; nxtTxtDtlVCtr=nil; }
////  nxtTxtDtlVCtr=[[TxtDtlVCtr alloc] initWithNibName:@"TxtDtlVCtr" bundle:nil];
////  nxtTxtDtlVCtr.str=StringRef();
////  [self.navigationController pushViewController:nxtTxtDtlVCtr animated:YES];
//    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"test" ofType:@"pdf"];
////    NSURL *url = [NSURL fileURLWithPath:pdfPath];
//    // 1. Open Document page
//    CGPDFDocumentRef document = MyGetPDFDocumentRef ([filePath UTF8String]);
//
//    int pgcnt = CGPDFDocumentGetNumberOfPages( document );
//
//    for( int i1 = 0; i1 < pgcnt; ++i1 ) {
//
//        CGPDFPageRef pg = CGPDFDocumentGetPage (document, i1+1);
//        if( !pg ) {
//            NSLog(@"Couldn't open page.");
//        } else {
//
//            // 2. get page dictionary
//            CGPDFDictionaryRef dict = CGPDFPageGetDictionary( pg );
//            if( !dict ) {
//                NSLog(@"Couldn't open page dictionary.");
//            } else {
//                // 3. get page contents stream
//                CGPDFStreamRef cont;
//                if( !CGPDFDictionaryGetStream( dict, "Contents", &cont ) ) {
//                    NSLog(@"Couldn't open page stream.");
//                } else {
//                    // 4. copy page contents steam
//                    //  CFDataRef contdata = CGPDFStreamCopyData( cont, NULL );
//
//                    // 5. get the media array from stream
//                    CGPDFArrayRef media;
//                    if( !CGPDFDictionaryGetArray( dict, "MediaBox", &media ) ) {
//                        NSLog(@"Couldn't open page Media.");
//                    } else {
//                        // 6. open media & get it's size
//                        CGPDFInteger mediatop, medialeft;
//                        CGPDFReal mediaright, mediabottom;
//                        if( !CGPDFArrayGetInteger( media, 0, &mediatop ) || !CGPDFArrayGetInteger( media, 1, &medialeft ) || !CGPDFArrayGetNumber( media, 2, &mediaright ) || !CGPDFArrayGetNumber( media, 3, &mediabottom ) ) {
//                            NSLog(@"Couldn't open page Media Box.");
//                        } else {
//                            // 7. set media size
//                            //      double mediawidth = mediaright - medialeft, mediaheight = mediabottom - mediatop;
//                            // 8. get media resources
//                            CGPDFDictionaryRef res;
//                            if( !CGPDFDictionaryGetDictionary( dict, "Resources", &res ) ) {
//                                NSLog(@"Couldn't Open Page Media Reopsources.");
//                            } else {
//                                // 9. get xObject from media resources
//                                CGPDFDictionaryRef xobj;
//                                if( !CGPDFDictionaryGetDictionary( res, "XObject", &xobj ) ) {
//                                    NSLog(@"Couldn't load page Xobjects.");
//                                } else {
//                                    CGPDFDictionaryApplyFunction(xobj, pdfDictionaryFunction, NULL);
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//
////    NSLog(@"Total images are - %i",[arrImgs count]);
////
////    if(nxtImgVCtr!=nil && [nxtImgVCtr retainCount]>0 ) { [nxtImgVCtr release]; nxtImgVCtr=nil; }
////    nxtImgVCtr=[[ImgVCtr alloc] initWithNibName:@"ImgVCtr" bundle:nil];
////    nxtImgVCtr.arrImg=arrImgs;
////    [self.navigationController pushViewController:nxtImgVCtr animated:YES];
//}

@end
