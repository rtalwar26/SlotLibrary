//
//  WinObject.h
//  JwelThiefIpad
//
//  Created by rajat talwar on 12/12/11.
//  Copyright (c) 2011 rajat. All rights reserved.
//

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
    NSInteger mScatterMult;
    NSInteger mWildMult;

    id<WinObjectProtocol> mDelegate;
    BOOL mScatterDetected;
    BOOL mWildDetected;
}
@property(nonatomic,readwrite)    NSInteger mScatterMult,mWildMult;
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
-(NSInteger)scatterMultiplier:(WinObject*)pWinObject;
@end
