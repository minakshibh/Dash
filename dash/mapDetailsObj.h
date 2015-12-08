//
//  mapDetailsObj.h
//  dash
//
//  Created by Krishna_Mac_1 on 4/20/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface mapDetailsObj : NSObject
@property (strong, nonatomic) NSString *latitudeStr, *longitudeStr,*placeRatingStr, *placeImage,*detailrName,*detailerContact,*detailrEmail,*workSampleId,*makeAndModelDetails,*beforeImageUrl,*afterImageUrl,*distance,*detailrId,*special_Requirement;

@property (strong, nonatomic) NSArray*workSamples;

@end
