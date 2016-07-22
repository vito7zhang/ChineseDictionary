//
//  NetWorking.h
//  dictionary1
//
//  Created by Macx on 16/7/20.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorking : NSObject <NSURLSessionDelegate,NSURLSessionDataDelegate>
@property (nonatomic,strong)NSURLSessionDownloadTask *downLoadTask;
@property (nonatomic,strong)NSURLSession *session;
-(void)getDataFromURL:(NSURL *)url;
@end
