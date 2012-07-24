//
//  WlSlot.h
//  JwelThiefIpad
//
//  Created by rajat talwar on 10/12/11.
//  Copyright (c) 2011 rajat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLReel.h"
#import "WinObject.h"
#define _WLNSINT(i) [NSNumber numberWithInt:(i)] 

#define REEL_SYMBOL_ARRAYS @"REEL_SYMBOL_ARRAYS"
#define SLOT_POS_X @"SLOT_POS_X"
#define SLOT_POS_Y @"SLOT_POS_Y"
#define DEFAULT_SLOT_POS_X 0.0
#define DEFAULT_SLOT_POS_Y 0.0
#define NUM_REELS @"NUM_REELS"
#define DEFAULT_SLOT_SCENE_ID 1000;
#define SLOT_SCENE_ID @"SLOT_SCENE_ID"
#define DEFAUTL_SLOT_REEL_HORIZONTAL_SPACING 0.0
#define SLOT_REEL_HORIZONTAL_SPACING @"SLOT_REEL_HORIZONTAL_SPACING"
#define NUMBER_OF_SYMBOLS_PER_REEL 3


 


@protocol WlSlotProtocol;

@interface WlSlot : NSObject<WlReelProtocol,WinObjectProtocol,NSURLConnectionDelegate>
{
    NSMutableArray *mReels;
    
    id<WlSlotProtocol> mDelegate;
    
    NSInteger mNumReels;
    CGFloat mReelWidth;
    CGFloat mReelHeight;
    CGFloat mReelHorizontalSpacing;
    NSMutableData *mRespData;
    CGFloat mSlotPosX;
    CGFloat mSlotPosY;
    CGFloat mSymbolHeight;
    CGFloat   mSymbolWidth;
    NSUInteger mNumRows;
    NSUInteger mStoppingReelNum;
    NSMutableArray *mSymbolArrays;
    
    NSMutableDictionary *mConfigDic;
    
    NSInteger mSlotSceneId;
    NSMutableArray *mStopPositions;
    NSMutableArray *mSlotState; // this 2d array stores the current state of slot in NSNumber form
    NSMutableArray *mSlotSymbols;
    NSMutableArray *mWinArray;
    NSMutableArray *mWinLineImageViews;
    int mSlotPos[5][3];
    NSInteger mWild;
    NSInteger mScatter;

    BOOL mSlotPlaying;
}
//-(int[][3])mSlotPos1;
-(id)initWithDelegate:(id)pDelegate andConfig:(NSMutableDictionary*)pConfig;
-(void)play;
-(void)stop;
-(void)continuePlay;
-(void)checkAllWinsForReel:(NSInteger)pReelIndex;
-(void)instantStop;
-(void)showLineWin:(WinObject*)pObj;
//@property(readonly)   int mSlotPos[5][3];
@property(nonatomic,readonly) CGFloat mReelHorizontalSpacing;

@property(nonatomic,retain)    NSMutableData *mRespData;
@property(nonatomic,readonly)CGFloat mReelHeight;
@property(nonatomic,readwrite)NSInteger mWild;
@property(nonatomic,readwrite)NSInteger mScatter;

@property(nonatomic,readonly)CGFloat mSlotPosX;
@property(nonatomic,readonly)CGFloat mSlotPosY;
@property(nonatomic,readonly)CGFloat mSymbolHeight;
@property(nonatomic,readonly)CGFloat   mSymbolWidth;
@property(nonatomic,readonly) BOOL mSlotPlaying;
  @property(nonatomic,readonly)  NSMutableArray *mWinLineImageViews;
@property(nonatomic,retain)    NSMutableArray *mWinArray;
@property(readonly) NSInteger mNumReels;
@property(readonly)NSUInteger mNumRows;
@property(nonatomic,retain) NSMutableArray *mSlotSymbols;

@property(nonatomic,retain)    NSMutableArray *mSlotState;
@property(nonatomic,retain)    NSMutableArray *mStopPositions;
@property(nonatomic,retain)NSMutableArray *mSymbolArrays;
@property(nonatomic,retain)   NSMutableDictionary *mConfigDic;
@property(nonatomic,retain)NSMutableArray *mReels;
@property(nonatomic,assign)    id<WlSlotProtocol> mDelegate;
-(void)halt;
-(void)cleanUpAnimData;


@end


@protocol WlSlotProtocol
-(UIView*)viewForDisplay: (WlSlot*)wlSlot;
-(void)wlSlot:(WlSlot*)pSlot didStoppedreel:(WLReel*)pReel atIndex:(NSInteger)pStopIndex symbol:(NSInteger)pSymbol;
-(void)wlSlotDidStopThisPlay:(WlSlot*)pSlot ;
@optional
-(BOOL)isScatterIsWild:(WlSlot*)pSlot;

@end