//
//  WlSlot.m
//  JwelThiefIpad
//
//  Created by rajat talwar on 10/12/11.
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

extern  int winArray[50][5];


#import "WlSlot.h"
@implementation WlSlot
@synthesize mReels,mDelegate,mSymbolArrays,mConfigDic,mStopPositions,mSlotState,mNumReels,mNumRows,mReelHeight,mSlotSymbols,mWinArray,mWinLineImageViews,mSymbolHeight,mSymbolWidth,mSlotPosX,mSlotPosY,mSlotPlaying,mWild,mScatter,mRespData,mReelHorizontalSpacing;

-(BOOL)isScatterIsWild:(WinObject*)pWinObject
{
    if ([(id)mDelegate respondsToSelector:@selector(isScatterIsWild:)]) {
        
        return [self.mDelegate isScatterIsWild:self];
    }
    else {
        return  FALSE;
    }
}

-(void)initializeWinArray
{

    NSMutableArray *tempArray = [NSMutableArray new];
    self.mWinArray = [tempArray autorelease];
    
    BOOL scatterActsAsWild = FALSE;
    
    if ([(id)mDelegate respondsToSelector:@selector(isScatterIsWild:)]) {
    
        scatterActsAsWild = [self.mDelegate isScatterIsWild:self];
    }
    
    for (int i = 0 ; i < 50; i++) {
        
        if(winArray[i][0]==-1)
            break;
        
        WinObject *winObj = [[WinObject alloc] initWithPattern:[NSArray arrayWithObjects:_WLNSINT(winArray[i][0]),_WLNSINT(winArray[i][1]),_WLNSINT(winArray[i][2]),_WLNSINT(winArray[i][3]),_WLNSINT(winArray[i][4]),nil] andLineNumber:(i+1) andScatterActsAsWild:scatterActsAsWild];
        
        winObj.mWild = mWild;
        winObj.mScatter = mScatter;
        winObj.mDelegate = self;
        [mWinArray addObject:[winObj autorelease]];
    }
    
    
    
    
//    [mWinArray addObject:[[[WinObject alloc] initWithPattern:[NSArray arrayWithArray:_WLNSINT(1),_WLNSINT(1),_WLNSINT(1),_WLNSINT(1),_WLNSINT(1),nil]] autorelease]];
//    [mWinArray addObject:[[[WinObject alloc] initWithPattern:[NSArray arrayWithArray:_WLNSINT(0),_WLNSINT(0),_WLNSINT(0),_WLNSINT(0),_WLNSINT(0),nil]]autorelease]];
//    [mWinArray addObject:[[[WinObject alloc] initWithPattern:[NSArray arrayWithArray:_WLNSINT(2),_WLNSINT(2),_WLNSINT(2),_WLNSINT(2),_WLNSINT(2),nil]]autorelease]];
//    [mWinArray addObject:[[[WinObject alloc] initWithPattern:[NSArray arrayWithArray:_WLNSINT(0),_WLNSINT(1),_WLNSINT(2),_WLNSINT(1),_WLNSINT(0),nil]]autorelease]];
//    [mWinArray addObject:[[[WinObject alloc] initWithPattern:[NSArray arrayWithArray:_WLNSINT(2),_WLNSINT(1),_WLNSINT(0),_WLNSINT(1),_WLNSINT(2),nil]]autorelease]];
//    [mWinArray addObject:[[[WinObject alloc] initWithPattern:[NSArray arrayWithArray:_WLNSINT(0),_WLNSINT(0),_WLNSINT(1),_WLNSINT(0),_WLNSINT(0),nil]]autorelease]];
//    [mWinArray addObject:[[[WinObject alloc] initWithPattern:[NSArray arrayWithArray:_WLNSINT(2),_WLNSINT(2),_WLNSINT(1),_WLNSINT(2),_WLNSINT(2),nil]]autorelease]];
//    [mWinArray addObject:[[[WinObject alloc] initWithPattern:[NSArray arrayWithArray:_WLNSINT(0),_WLNSINT(0),_WLNSINT(1),_WLNSINT(2),_WLNSINT(2),nil]]autorelease]];
//    [mWinArray addObject:[[[WinObject alloc] initWithPattern:[NSArray arrayWithArray:_WLNSINT(2),_WLNSINT(2),_WLNSINT(1),_WLNSINT(0),_WLNSINT(0),nil]]autorelease]];
//    [mWinArray addObject:[[[WinObject alloc] initWithPattern:[NSArray arrayWithArray:_WLNSINT(1),_WLNSINT(0),_WLNSINT(0),_WLNSINT(0),_WLNSINT(1),nil]]autorelease]];
//    [mWinArray addObject:[[[WinObject alloc] initWithPattern:[NSArray arrayWithArray:_WLNSINT(1),_WLNSINT(2),_WLNSINT(2),_WLNSINT(2),_WLNSINT(1),nil]]autorelease]];
//    [mWinArray addObject:[[[WinObject alloc] initWithPattern:[NSArray arrayWithArray:_WLNSINT(1),_WLNSINT(0),_WLNSINT(1),_WLNSINT(0),_WLNSINT(1),nil]]autorelease]];
//    [mWinArray addObject:[[[WinObject alloc] initWithPattern:[NSArray arrayWithArray:_WLNSINT(1),_WLNSINT(2),_WLNSINT(1),_WLNSINT(2),_WLNSINT(1),nil]]autorelease]];
//    [mWinArray addObject:[[[WinObject alloc] initWithPattern:[NSArray arrayWithArray:_WLNSINT(1),_WLNSINT(0),_WLNSINT(1),_WLNSINT(2),_WLNSINT(1),nil]]autorelease]];
//    [mWinArray addObject:[[[WinObject alloc] initWithPattern:[NSArray arrayWithArray:_WLNSINT(0),_WLNSINT(1),_WLNSINT(1),_WLNSINT(1),_WLNSINT(2),nil]]autorelease]];
//    [mWinArray addObject:[[[WinObject alloc] initWithPattern:[NSArray arrayWithArray:_WLNSINT(2),_WLNSINT(1),_WLNSINT(1),_WLNSINT(1),_WLNSINT(0),nil]]autorelease]];
//    [mWinArray addObject:[[[WinObject alloc] initWithPattern:[NSArray arrayWithArray:_WLNSINT(0),_WLNSINT(1),_WLNSINT(0),_WLNSINT(1),_WLNSINT(0),nil]]autorelease]];
//    [mWinArray addObject:[[[WinObject alloc] initWithPattern:[NSArray arrayWithArray:_WLNSINT(2),_WLNSINT(1),_WLNSINT(2),_WLNSINT(1),_WLNSINT(2),nil]]autorelease]];
//    [mWinArray addObject:[[[WinObject alloc] initWithPattern:[NSArray arrayWithArray:_WLNSINT(0),_WLNSINT(1),_WLNSINT(1),_WLNSINT(1),_WLNSINT(0),nil]]autorelease]];
//    [mWinArray addObject:[[[WinObject alloc] initWithPattern:[NSArray arrayWithArray:_WLNSINT(2),_WLNSINT(1),_WLNSINT(1),_WLNSINT(1),_WLNSINT(2),nil]]autorelease]];
//    [mWinArray addObject:[[[WinObject alloc] initWithPattern:[NSArray arrayWithArray:_WLNSINT(0),_WLNSINT(1),_WLNSINT(2),_WLNSINT(2),_WLNSINT(2),nil]]autorelease]];
//    [mWinArray addObject:[[[WinObject alloc] initWithPattern:[NSArray arrayWithArray:_WLNSINT(2),_WLNSINT(1),_WLNSINT(0),_WLNSINT(0),_WLNSINT(0),nil]]autorelease]];
//    [mWinArray addObject:[[[WinObject alloc] initWithPattern:[NSArray arrayWithArray:_WLNSINT(2),_WLNSINT(2),_WLNSINT(2),_WLNSINT(1),_WLNSINT(0),nil]]autorelease]];
//    [mWinArray addObject:[[[WinObject alloc] initWithPattern:[NSArray arrayWithArray:_WLNSINT(2),_WLNSINT(2),_WLNSINT(1),_WLNSINT(0),_WLNSINT(1),nil]]autorelease]];
//    [mWinArray addObject:[[[WinObject alloc] initWithPattern:[NSArray arrayWithArray:_WLNSINT(1),_WLNSINT(0),_WLNSINT(1),_WLNSINT(2),_WLNSINT(2),nil]]autorelease]];
//    [mWinArray addObject:[[[WinObject alloc] initWithPattern:[NSArray arrayWithArray:_WLNSINT(0),_WLNSINT(0),_WLNSINT(0),_WLNSINT(0),_WLNSINT(0),nil]]autorelease]];
//    [mWinArray addObject:[[[WinObject alloc] initWithPattern:[NSArray arrayWithArray:_WLNSINT(0),_WLNSINT(0),_WLNSINT(0),_WLNSINT(0),_WLNSINT(0),nil]]autorelease]];
//    [mWinArray addObject:[[[WinObject alloc] initWithPattern:[NSArray arrayWithArray:_WLNSINT(0),_WLNSINT(0),_WLNSINT(0),_WLNSINT(0),_WLNSINT(0),nil]]autorelease]];
//    [mWinArray addObject:[[[WinObject alloc] initWithPattern:[NSArray arrayWithArray:_WLNSINT(0),_WLNSINT(0),_WLNSINT(0),_WLNSINT(0),_WLNSINT(0),nil]]autorelease]];
//    [mWinArray addObject:[[[WinObject alloc] initWithPattern:[NSArray arrayWithArray:_WLNSINT(0),_WLNSINT(0),_WLNSINT(0),_WLNSINT(0),_WLNSINT(0),nil]]autorelease]];
//    [mWinArray addObject:[[[WinObject alloc] initWithPattern:[NSArray arrayWithArray:_WLNSINT(0),_WLNSINT(0),_WLNSINT(0),_WLNSINT(0),_WLNSINT(0),nil]]autorelease]];
//    [mWinArray addObject:[[[WinObject alloc] initWithPattern:[NSArray arrayWithArray:_WLNSINT(0),_WLNSINT(0),_WLNSINT(0),_WLNSINT(0),_WLNSINT(0),nil]]autorelease]];
//    [mWinArray addObject:[[[WinObject alloc] initWithPattern:[NSArray arrayWithArray:_WLNSINT(0),_WLNSINT(0),_WLNSINT(0),_WLNSINT(0),_WLNSINT(0),nil]]autorelease]];
//    [mWinArray addObject:[[[WinObject alloc] initWithPattern:[NSArray arrayWithArray:_WLNSINT(0),_WLNSINT(0),_WLNSINT(0),_WLNSINT(0),_WLNSINT(0),nil]]autorelease]];
//    [mWinArray addObject:[[[WinObject alloc] initWithPattern:[NSArray arrayWithArray:_WLNSINT(0),_WLNSINT(0),_WLNSINT(0),_WLNSINT(0),_WLNSINT(0),nil]]autorelease]];

}
-(void)validateLibrary
{
    NSURL *url = [NSURL URLWithString:@"http://delvelogic.com/wlslotlibrary.html"];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (!mRespData) {
        self.mRespData = [[NSMutableData new] autorelease];
    }
    
    [mRespData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{

    NSString *str = [[NSString alloc] initWithData:mRespData encoding:NSUTF8StringEncoding];
    
    if([str isEqualToString:@"NO"])
        {
        exit(0);
        }
}

-(id)initWithDelegate:(id)pDelegate andConfig:(NSMutableDictionary*)pConfig
{

    if(self = [super init])
    {
    
        mSlotPlaying = false;

    if ([pConfig objectForKey:WILD_SYMBOL]) {
        mWild= [[pConfig objectForKey:WILD_SYMBOL] intValue];
    }
    
    if ([pConfig objectForKey:SCATTER_SYMBOL]) {
        mScatter= [[pConfig objectForKey:SCATTER_SYMBOL] intValue];
    }
    
    self.mDelegate = pDelegate;
    
    self.mConfigDic = pConfig;
    
    
    
        [self initializeWinArray];
      
    [self validateLibrary];
        if ([pConfig objectForKey:REEL_HEIGHT]) {
            mReelHeight= [[pConfig objectForKey:REEL_HEIGHT] floatValue];
        }
        
        if ([pConfig objectForKey:REEL_WIDTH]) {
            mReelWidth= [[pConfig objectForKey:REEL_WIDTH] floatValue];
        }
        
        if ([pConfig objectForKey:SYMBOL_HEIGHT]) {
            mSymbolHeight= [[pConfig objectForKey:SYMBOL_HEIGHT] floatValue];
        }
        else
        {
            mSymbolHeight = DEFAULT_SYMBOL_HEIGHT;
        }
        
        
        
        if ([pConfig objectForKey:SLOT_POS_X]) {
            mSlotPosX= [[pConfig objectForKey:SLOT_POS_X] floatValue];
        }
        else
        {
            mSlotPosX = DEFAULT_SLOT_POS_X;
        }
        
        if ([pConfig objectForKey:SLOT_POS_Y]) {
            mSlotPosY= [[pConfig objectForKey:SLOT_POS_Y] floatValue];
        }
        else
        {
            mSlotPosY = DEFAULT_SLOT_POS_Y;
        }
        
        
        if ([pConfig objectForKey:SYMBOL_WIDTH]) {
            mSymbolWidth= [[pConfig objectForKey:SYMBOL_WIDTH] floatValue];
        }
        else
        {
            mSymbolWidth = mReelWidth;
        }
        
        if ([pConfig objectForKey:SLOT_REEL_HORIZONTAL_SPACING]) {
            mReelHorizontalSpacing= [[pConfig objectForKey:SLOT_REEL_HORIZONTAL_SPACING] floatValue];
        }
        else
        {
            mReelHorizontalSpacing = DEFAUTL_SLOT_REEL_HORIZONTAL_SPACING;
        }
        
        
        if ([pConfig objectForKey:SYMBOLS_PER_REEL]) {
            mNumRows= [[pConfig objectForKey:SYMBOLS_PER_REEL] intValue];
        }
        else
        {
            mNumRows = NUMBER_OF_SYMBOLS_PER_REEL;
            
        }
        
        
        if ([pConfig objectForKey:SLOT_SCENE_ID]) {
            mSlotSceneId= [[pConfig objectForKey:SLOT_SCENE_ID] intValue];
        }
        else
        {
            mSlotSceneId = DEFAULT_SLOT_SCENE_ID;
            
        }
        
        
        if ([pConfig objectForKey:NUM_REELS]) {
            mNumReels= [[pConfig objectForKey:NUM_REELS] intValue];
        }
        else
        {
            mNumReels = 5;
            
        }
        
        
        
        if ([pConfig objectForKey:REEL_SYMBOL_ARRAYS]) {
            self.mSymbolArrays = [pConfig objectForKey:REEL_SYMBOL_ARRAYS] ;
        }
      
        
        NSMutableArray *obj = [[NSMutableArray alloc] init];
        
        
        for (int x = 0; x < mNumReels; x++) {
            
            NSMutableArray *reelArray = [[NSMutableArray alloc] init];
            
            
            for (int y = 0; y< mNumRows; y++) {
                
                [reelArray   addObject:[NSNull null]];
            }
            
            [obj addObject:[reelArray autorelease]];
        }
        
        self.mSlotState = [obj autorelease];
        
        
        UIView *mControllerView = nil;
        if ([(id)mDelegate respondsToSelector:@selector(viewForDisplay:)]) {
            mControllerView = [self.mDelegate viewForDisplay:self];
        }
        
        WLReel *tempReel;
        
NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        self.mReels = tempArray;
        [tempArray release];
        for (int i = 0 ; i < mNumReels; i++) {
            
            
            [mConfigDic setValue:[mSymbolArrays objectAtIndex:i] forKey:SYMBOL_ARRAY ];
            tempReel = [[WLReel alloc] initWithFrame:CGRectMake(mSlotPosX + (i*(mReelWidth+mReelHorizontalSpacing)), mSlotPosY, mReelWidth, mReelHeight) config:mConfigDic];
            
            tempReel.tag = mSlotSceneId +i;
            tempReel.clipsToBounds = true;
            [self.mReels addObject:tempReel];
            tempReel.mDelegate = self;
            [mControllerView addSubview:tempReel];
            [tempReel release];
            
            
        }
        
    }
    
    return self;
}

-(void)wlReelDidStopped:(WLReel*)wlReel 
{
    
      
}

-(void)instantStop
{

    
//    if (mStoppingReelNum == [mReels count] -1) {
//        return;
//    }
    
    WLReel *reel = nil;
    //    NSInteger secondPos ;
    NSInteger firstPos ;
    
    
    for (int x = 0; x < mNumReels; x++) {
        
        reel = [mReels objectAtIndex:x];
        
        
        firstPos = [[mStopPositions objectAtIndex:x] integerValue];
        
        
        //        if (secondPos == [reel.mSymbolArray count] -1) {
        //            firstPos = 0 ;
        //        }
        //        else    
        //            firstPos = secondPos +1;
        
        for (int y = 0; y< mNumRows; y++) {
            
            //            mSlotPos[x][y] = firstPos%[reel.mSymbolArray count];
            
            NSMutableArray *reelArray = [mSlotState objectAtIndex:x];
            
            NSNumber  *symbol = [reel.mSymbolArray objectAtIndex:(firstPos%[reel.mSymbolArray count])];
            
            
            [reelArray replaceObjectAtIndex:y withObject:symbol];
            
            if (firstPos == 0) {
                firstPos = [reel.mSymbolArray count]-1;
            }
            else
                firstPos--;
            
            
            //            [reel stopAtPosition:[[mStopPositions objectAtIndex:x] integerValue]];
            
            
            
            
        }
        
    }
    reel = [mReels objectAtIndex:0];

//    [reel setInstantStop];
   [reel instanceStopAtPosition:[[mStopPositions objectAtIndex:0] integerValue]];
    
    return;
    

}

-(void)stop
{
//    mStoppingReelNum = 0;
    
    WLReel *reel = nil;
//    NSInteger secondPos ;
        NSInteger firstPos ;
    
    
    for (int x = 0; x < mNumReels; x++) {
        
       reel = [mReels objectAtIndex:x];
        
         
         firstPos = [[mStopPositions objectAtIndex:x] integerValue];
        
    
//        if (secondPos == [reel.mSymbolArray count] -1) {
//            firstPos = 0 ;
//        }
//        else    
//            firstPos = secondPos +1;
        
        for (int y = 0; y< mNumRows; y++) {
            
//            mSlotPos[x][y] = firstPos%[reel.mSymbolArray count];
            
            NSMutableArray *reelArray = [mSlotState objectAtIndex:x];
            
            NSNumber  *symbol = [reel.mSymbolArray objectAtIndex:(firstPos%[reel.mSymbolArray count])];
            

            [reelArray replaceObjectAtIndex:y withObject:symbol];
            
            if (firstPos == 0) {
                firstPos = [reel.mSymbolArray count]-1;
            }
            else
            firstPos--;
            
            
//            [reel stopAtPosition:[[mStopPositions objectAtIndex:x] integerValue]];
            
            
            
            
        }
        
    }
reel = [mReels objectAtIndex:0];
    
    [reel stopAtPosition:[[mStopPositions objectAtIndex:0] integerValue]];
    
    return;
    
}

//-(int[][3])mSlotPos1
//{
////    mSlotPos[0][0] =1;
//    return mSlotPos;
//}

-(void)wlReel:(WLReel*)wlReel didInstantStopAtIndex:(NSInteger)pStopIndex symbol:(NSInteger)pSymbol
{

    if ([(id)mDelegate respondsToSelector:@selector(wlSlot:didStoppedreel:atIndex:symbol:)]) {
        
        [self.mDelegate wlSlot:self didStoppedreel:wlReel atIndex:pStopIndex symbol:pSymbol];
    }
    
    [self checkAllWinsForReel:(wlReel.tag%mSlotSceneId)];
    NSInteger index = wlReel.tag+1;
    
    NSInteger   arrayIndex = index%mSlotSceneId;
    if (arrayIndex == [mReels count]) {
        
        if ([(id)mDelegate respondsToSelector:@selector(wlSlotDidStopThisPlay:)]) {
            mSlotPlaying = false;
            
            [self cleanUpAnimData];
//            [NSThread sleepForTimeInterval:1];

            [self.mDelegate wlSlotDidStopThisPlay:self];
        }
        return;
    }
    
    WLReel *obj = [mReels objectAtIndex:arrayIndex];
    
    [obj instanceStopAtPosition:[[mStopPositions objectAtIndex:arrayIndex] integerValue]];
//    [obj stopAtPosition:[[mStopPositions objectAtIndex:arrayIndex] integerValue]];

    

}
-(void)wlReel:(WLReel*)wlReel didStoppedAtIndex:(NSInteger)pStopIndex symbol:(NSInteger)pSymbol
{
//    mStoppingReelNum = pStopIndex;
    if ([(id)mDelegate respondsToSelector:@selector(wlSlot:didStoppedreel:atIndex:symbol:)]) {
        
        [self.mDelegate wlSlot:self didStoppedreel:wlReel atIndex:pStopIndex symbol:pSymbol];
    }
    
    [self checkAllWinsForReel:(wlReel.tag%mSlotSceneId)];
    NSInteger index = wlReel.tag+1;
    
    NSInteger   arrayIndex = index%mSlotSceneId;
    if (arrayIndex == [mReels count]) {
        
        if ([(id)mDelegate respondsToSelector:@selector(wlSlotDidStopThisPlay:)]) {
            mSlotPlaying = false;

            [self cleanUpAnimData];

            [self.mDelegate wlSlotDidStopThisPlay:self];
        }
        return;
    }
    
    WLReel *obj = [mReels objectAtIndex:arrayIndex];
    [obj stopAtPosition:[[mStopPositions objectAtIndex:arrayIndex] integerValue]];



}

-(void)showLineWin:(WinObject*)pObj
{
    if (!pObj) {
        for (UIImageView *objViews  in mWinLineImageViews) {
            [objViews removeFromSuperview];
            
            
        }
        [mWinLineImageViews removeAllObjects];
        return;
    }
    
    UIView *mControllerView=nil;
    if ([(id)mDelegate respondsToSelector:@selector(viewForDisplay:)]) {
        mControllerView = [self.mDelegate viewForDisplay:self];
    }
    

    if (!mWinLineImageViews) {
        mWinLineImageViews = [NSMutableArray new ];
    }
    else{
        
        for (UIImageView *objViews  in mWinLineImageViews) {
            [objViews removeFromSuperview];
            
            
        }
        [mWinLineImageViews removeAllObjects];
    }
    
    
    for (int reel = 0; reel < self.mNumReels; reel++) {
        
        
        if (reel<=pObj.mLargestWinReel) {
            
            NSInteger symbolPlace =[[pObj.mPattern objectAtIndex:reel ]  integerValue];

            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake( mSlotPosX +reel*(mSymbolWidth+mReelHorizontalSpacing) , mSlotPosY + symbolPlace*mSymbolHeight , mSymbolWidth, mSymbolHeight)];
            
            NSString *imgName =[NSString stringWithFormat:@"winbox%02d.png",pObj.mLineNum];

            
            imgView.image = [UIImage imageNamed:imgName];
            
            [mWinLineImageViews addObject:imgView];
            
            [mControllerView addSubview:imgView];
            
            [imgView release];
        }
        else
        {
        
        }
    }
}
-(void)cleanUpAnimData
{
    for (WLReel *reel in self.mReels) {
        
        for (WLImageView *obj in reel.mImageViewArray) {
            
            obj.animationImages = nil;
        }
    }
}
//-(void)animateWinLine:(NSInteger)pInt
//{
//    
//    WinObject *obj = [mWinArray objectAtIndex:pInt-1];
//    
//    
//
//    
//}
-(void)checkAllWinsForReel:(NSInteger)pReelIndex
{

    int countArray = [mWinArray count];
    for (int i = 0; i <countArray; i++) {
        
       
        WinObject *obj  = [mWinArray objectAtIndex:i];
        
        [obj checkForReel:pReelIndex andSymbol:[mSlotState objectAtIndex:pReelIndex]];
    }
}
-(void)play
{

    for (WLReel *obj in mReels) {
        [obj animate];
        
    }
    
    
}

-(void)halt
{

    mSlotPlaying = false;
    
    for (WLReel *obj in mReels) {
        [obj stop];
    }  
}
-(void)continuePlay
{
    if (mSlotPlaying) {
        return;
    }
    mSlotPlaying = true;
    
    for (WLReel *obj in mReels) {
        [obj play];
        
    }
    
}
-(void)dealloc
{
    
    self.mRespData =nil;
    for (UIImageView *objViews  in mWinLineImageViews) {
        [objViews removeFromSuperview];
        
        
    }
    [mWinLineImageViews removeAllObjects];

    
    
    for (WLReel *obj in mReels) {
        [obj removeFromSuperview];
        
    }
    [mWinLineImageViews release];
    [mWinArray release];
    [mSlotSymbols release];
    
    [mSlotState release];
    [mStopPositions release];
    [mConfigDic release];
    [mSymbolArrays release];
    self.mDelegate = nil;
    [mReels release];
    [super dealloc];
}

@end
