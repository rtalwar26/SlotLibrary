//
//  WLReel.h
//  JewelThiefIphone
//
//  Created by rajat talwar on 27/11/11.
//  Copyright (c) 2011 rajat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import "WLImageView.h"

#define GOOD_REELS 1 
#define COREANIMATION_USED 1
#define STOP_POSITION_GAP 5

#define SYMBOL_HEIGHT @"SymbolHeight"
#define SYMBOL_WIDTH @"SymbolWidth"
#define REEL_HEIGHT @"ReelHeight"
#define WILD_SYMBOL @"WILD_SYMBOL"
#define SCATTER_SYMBOL @"SCATTER_SYMBOL"

#define REEL_WIDTH @"ReelWidth"
#define VERTICAL_SPACING @"VerticalSpacing"
#define SYMBOL_ARRAY @"SymbolArray"
#define SYMBOLS_PER_REEL @"SymbolsPerReel"


#define TRAVERSE_DIVISOR 5
#define ANIMATION_PROPERTY @"position"
#define ANIMATION_DURATION 0.04

#define DEFAULT_SYMBOL_HEIGHT 70
#define DEFAULT_VERTICAL_SPACING 0
//#define  DAMPING_FACTOR 1.8
#ifdef GOOD_REELS
#define  DAMPING_FACTOR 5

#else
#define  DAMPING_FACTOR 1.4

#endif
enum WL_REEL_STATES {
    WL_REEL_RUNNING,
        WL_REEL_STOPPED,
        WL_REEL_STOPPING,
    WL_REEL_INSTANT_STOP,
    WL_REEL_INSTANT_STOPPING
    

    };
@class AppHelper;
@protocol WlReelProtocol;


@interface WLReel : UIView
{
    
    CGFloat mSymbolHeight;
    CGFloat mSymbolWidth;
//    CGFloat mVerticalSpacing;
    CGFloat mReelHeight;
    CGFloat mReelWidth;
    CGFloat mOriginalTraverse;
    NSMutableArray *mImageViewArray;
    NSArray *mSymbolArray; // this array stores the symbols in NSNumber form
    NSInteger mCurrentIndex;
    NSInteger mSymbolCount;
    NSInteger mTopFrameIndex;
        NSInteger mCurrentSymbolIndex;
    NSUInteger mNumberOfSymbolsPerReel;
    NSInteger mReelState;
    CGFloat mTraverseAmount;
    CGFloat mReelRoundUpPoint; //at this point the last frame is moved upwards to be shown again in the reel
    CGFloat mFrameRate;
    CGFloat mReelInitialisationPoint; //at this point the last frame has been moved upwards to be shown again in the reel

    CGFloat mSymbolTotalHeight;
    BOOL mDampingActive;
    id <WlReelProtocol> mDelegate;
    NSInteger mStopIndex;
    
    WLImageView *prevFrame;
    WLImageView *firstFrame;
    NSInteger mFirstFrameIndex;
    

}

@property(nonatomic,readwrite)CGFloat mFrameRate;

@property(atomic,readwrite)    CGFloat mTraverseAmount;


@property(nonatomic,assign)    id <WlReelProtocol> mDelegate;

@property(nonatomic,retain)    NSMutableArray *mImageViewArray;
@property(nonatomic,retain)NSArray *mSymbolArray;
-(void)animateSymbol:(NSNumber*)pSymbolIndexNum;
- (id)initWithFrame:(CGRect)frame config:(NSMutableDictionary*)pConfig;
-(void)animateThis:(WLImageView*)pImageView withtraverseAmount:(CGFloat)ptraverseAmount;
-(CABasicAnimation*)getAnimationforPoint:(CGPoint)pPoint traverseAmount:(CGFloat)pAmount;
-(NSString*)getSymbolAtIndex:(NSInteger)pIndex;
-(void)animate;
-(void)stop;
-(void)stopAtOffset:(CGFloat)pOffset;
-(void)play;
-(void)stopping;
-(void)stopAtPosition:(NSInteger)pPos;
-(void)killAllAnimations;
-(void)moveReel;
-(BOOL)shouldStopAtFrameFound;
-(void)animateAllFrames;
-(void)instanceStopAtPosition:(NSInteger)pPos;
-(void)instantStopAtOffset:(CGFloat)pOffset;
-(void)instantAnimateThis:(WLImageView*)pImageView withtraverseAmount:(CGFloat)ptraverseAmount;
-(void)instantAnimateAllFrames;
-(BOOL)instantShouldStopAtFrameFound;
-(void)instantMoveReel;
-(WLImageView*)getImageViewAtRowIndex:(NSNumber*)pSymbolIndexNum;
-(void)hideSymbol:(NSNumber*)pSymbolIndexNum forInterval:(NSTimeInterval)pInterval;
-(void)showImageView:(WLImageView*)pImageView;
-(CABasicAnimation*)getStopAnimationforPoint:(CGPoint)pPoint traverseAmount:(CGFloat)pAmount;
-(NSString*)getSymbolAtIndex:(NSInteger)pIndex forWlImageView:(WLImageView*)pImageView;

@end

@protocol WlReelProtocol

@optional
-(void)wlReel:(WLReel*)wlReel didStoppedAtIndex:(NSInteger)pStopIndex symbol:(NSInteger)pSymbol;
-(void)wlReel:(WLReel*)wlReel didInstantStopAtIndex:(NSInteger)pStopIndex symbol:(NSInteger)pSymbol;

@end

