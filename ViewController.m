//
//  ViewController.m
//  CutLongPic
//
//
//  Copyright © 2017年 GG. All rights reserved.
//

#import "ViewController.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
@interface ViewController ()<UIWebViewDelegate>

@property(nonatomic, strong)UIWebView *webView ;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    
    //iOS10中需要添加权限,在info.plist中添加  否则会crash
    //key :Privacy - Photo Library Usage Description   value: string类型:photoLibraryDesciption
    
    [super viewDidLoad];
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, self.view.frame.size.height)];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
    _webView.delegate = self;
    [self.view addSubview:_webView];


    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 50, 40);
    [rightBtn setTitle:@"截图" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(cutPic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];

    

}
- (void)cutPic{
    CGRect snapshotFrame = CGRectMake(0, 0, _webView.scrollView.contentSize.width, _webView.scrollView.contentSize.height);
    UIEdgeInsets snapshotEdgeInsets = UIEdgeInsetsZero;
    UIImage *shareImage = [self snapshotViewFromRect:snapshotFrame withCapInsets:snapshotEdgeInsets];
    //设置一个图片的存储路径
    [self loadImageFinished:shareImage];
}
- (void)loadImageFinished:(UIImage *)image
{
    __block ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
    [lib writeImageToSavedPhotosAlbum:image.CGImage metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        
        NSLog(@"assetURL = %@, error = %@", assetURL, error);
        lib = nil;
        
    }];
}
- (UIImage *)snapshotViewFromRect:(CGRect)rect withCapInsets:(UIEdgeInsets)capInsets {
    
    CGFloat scale = [UIScreen mainScreen].scale;
    
    CGSize boundsSize = self.webView.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    
    CGSize contentSize = self.webView.scrollView.contentSize;
    CGFloat contentHeight = contentSize.height;
    CGFloat contentWidth = contentSize.width;
    
    CGPoint offset = self.webView.scrollView.contentOffset;
    
    [self.webView.scrollView setContentOffset:CGPointMake(0, 0)];
    
    NSMutableArray *images = [NSMutableArray array];
    while (contentHeight > 0) {
        UIGraphicsBeginImageContextWithOptions(boundsSize, NO, [UIScreen mainScreen].scale);
        [self.webView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [images addObject:image];
        
        CGFloat offsetY = self.webView.scrollView.contentOffset.y;
        [self.webView.scrollView setContentOffset:CGPointMake(0, offsetY + boundsHeight)];
        contentHeight -= boundsHeight;
    }
    
    
    [self.webView.scrollView setContentOffset:offset];
    
    CGSize imageSize = CGSizeMake(contentSize.width * scale,
                                  contentSize.height * scale);
    UIGraphicsBeginImageContext(imageSize);
    [images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
        [image drawInRect:CGRectMake(0,
                                     scale * boundsHeight * idx,
                                     scale * boundsWidth,
                                     scale * boundsHeight)];
    }];
    UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView * snapshotView = [[UIImageView alloc]initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)];
    
    snapshotView.image = [fullImage resizableImageWithCapInsets:capInsets];
    //    [self loadImageFinished:fullImage];
    
    return snapshotView.image;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
