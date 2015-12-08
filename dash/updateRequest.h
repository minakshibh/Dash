//
//  updateRequest.h
//  dash
//
//  Created by Krishna_Mac_1 on 6/8/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
@protocol updateRequestStatus <NSObject>

@optional
- (void)ReceivedResponse ;

@end

@interface updateRequest : NSObject
{
    id <updateRequestStatus> updateRequestdelegate;
    NSMutableData* webData;
    int webservice;
    NSString*triggerValue;
    NSString *statusRecived;
    NSString *serviceID;
    NSData *image1;
    
    
}
@property (strong, nonatomic) UINavigationController *navigator;
@property(nonatomic, assign) id <updateRequestStatus> updateRequestdelegate;

- (NSString *)updateRequestStatus: (NSString *)status delegate: (id)theDelegate service_id: (NSString*)service_id startPic: (NSString *)startPic endPic: (NSString *) endpic;
-(void )updateRequestWithImage : (NSString *)status delegate: (id)theDelegate service_id: (NSString*)service_id startPic: (NSData *)startPic endPic: (NSData *) endpic;
-(NSString *)statusValue;
@end
