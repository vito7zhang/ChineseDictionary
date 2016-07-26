//
//  NetWorking.m
//  dictionary1
//
//  Created by Macx on 16/7/20.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "NetWorking.h"

@implementation NetWorking
-(void)getDataFromURL:(NSURL *)url{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    self.downLoadTask = [self.session downloadTaskWithRequest:request];
    [_downLoadTask resume];
}
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    if ([location hasDirectoryPath] == NO) {
//        NSURL *url = [NSURL fileURLWithPath:[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject] stringByAppendingPathComponent:@""]];
//        NSFileManager *fileManager = [NSFileManager defaultManager];
        
    }
}
@end












