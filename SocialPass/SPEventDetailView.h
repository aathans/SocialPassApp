//
//  SPEventDetailView.h
//  SocialPass
//
//  Created by Alexander Athan on 7/10/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPEventDetailView : UIView

@property (nonatomic) UIButton *cancelButton;
@property (nonatomic) UILabel *eventDesc;
@property (nonatomic) UILabel *eventOrganizer;
@property (nonatomic) UILabel *eventTime;
@property (nonatomic) UILabel *attendees;
@property (nonatomic) UIImageView *eventPhoto;
@property (nonatomic) UICollectionView *attendeePhotos;


@end
