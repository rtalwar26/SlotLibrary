//
//  WinObject.h
//  JwelThiefIpad
//
//  Created by rajat talwar on 12/12/11.
//  Copyright (c) 2011 rajat. All rights reserved.
//
/*Disclaimer: IMPORTANT:  This  software is supplied to you by Delvelogic Pvt Ltd
 in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Delvelogic Pvt LTd software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Delvelogic Pvt Ltd software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Delvelogic grants you a personal, non-exclusive
 license, under Delvelogic's copyrights in this original Delvelogic software (the
 "Delvelogic Software"), to use, reproduce, modify and redistribute the Delvelogic
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Delvelogic Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Delvelogic Software.
 Neither the name, trademarks, service marks or logos of Delvelogic Pvt ltd. may
 be used to endorse or promote products derived from the Delvelogic Software
 without specific prior written permission from Delvelogic.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Delvelogic herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Delvelogic Software may be incorporated.
 */
#import <Foundation/Foundation.h>
@class AppHelper;

@protocol WinObjectProtocol;
@interface WinObject : NSObject
{

    BOOL mAlive;
    NSMutableArray *mPattern;
    NSInteger mLineNum;
    NSMutableArray *mThisPlayState;
    NSInteger mLargestWinReel;
    NSInteger mWinSymbol;
    NSInteger mThisWin;
    NSTimer *mTimer;
    NSInteger mWild;
    NSInteger mScatter;
    BOOL mScatterIsWild;
    id<WinObjectProtocol> mDelegate;
}
@property(nonatomic,assign)    id<WinObjectProtocol> mDelegate;
@property(nonatomic,readwrite)NSInteger mScatter;

@property(nonatomic,readwrite)    NSInteger mWild;
@property(readonly)    BOOL mAlive;
@property(nonatomic,retain)     NSTimer *mTimer;
@property(nonatomic,retain)       NSMutableArray *mThisPlayState;
@property(nonatomic,retain)    NSMutableArray *mPattern;
@property(nonatomic,readonly) NSInteger mLargestWinReel;
@property(nonatomic,readonly)     NSInteger mWinSymbol;
@property(readonly)    NSInteger mLineNum;
-(id)initWithPattern:(NSArray*)pPattern andLineNumber:(NSInteger)pLine andScatterActsAsWild:(BOOL)pScatterIsWild ;
-(BOOL)behavesAsWild:(NSNumber*)pNum;


-(BOOL)checkForReel:(NSInteger)pReel andSymbol:(NSMutableArray*)pSlotReel;-(NSInteger)winAmount;
-(NSInteger)winAnimationTime;
+(NSInteger)winTimeForSymbol:(NSInteger)mWinSymbol;

@end

@protocol WinObjectProtocol

@optional
-(BOOL)isScatterIsWild:(WinObject*)pWinObject;
@end
