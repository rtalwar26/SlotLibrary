//
//  WinObject.m
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
#import "WinObject.h"

extern const int symbolWins[][5];
extern const int symbolLeastWin[];

extern const char *symbolImageArray[];
extern const char *symbolAnimarray[];
@implementation WinObject

@synthesize  mPattern,mAlive,mThisPlayState,mLineNum,mLargestWinReel,mWinSymbol,mTimer,mWild,mDelegate,mScatter,mScatterMult,mWildMult;
-(id)initWithPattern:(NSArray*)pPattern andLineNumber:(NSInteger)pLine andScatterActsAsWild:(BOOL)pScatterIsWild {
    mAlive = TRUE;
   mWildMult = mScatterMult = 1;
    mScatterIsWild = pScatterIsWild;
    if (self = [super init]) {
        
    
        mLineNum = pLine;
        mPattern = [[NSMutableArray alloc] init];
        mThisPlayState = [NSMutableArray new];
        for (NSNumber *obj in pPattern) {

            [mPattern addObject:obj];
            [mThisPlayState addObject:[NSNull null]];
        }
    }
    
    return  self;

}

-(BOOL)behavesAsWild:(NSNumber*)pNum
{

    if ([pNum integerValue] == mWild) {
        mWildDetected = true;
        return TRUE;
    }
    
    if ( [pNum integerValue]== mScatter) {
        mScatterDetected = true;
        return mScatterIsWild;
    }
    
    return FALSE;
}
-(BOOL)checkForReel:(NSInteger)pReel andSymbol:(NSMutableArray*)pSlotReel
{
    NSInteger rowNum = [[mPattern objectAtIndex:pReel] integerValue];
    
    if(pReel == 0){
        mWildMult = mScatterDetected= false;

        mWinSymbol = -1;
        mThisWin=0;
        [mThisPlayState replaceObjectAtIndex:pReel withObject:[pSlotReel objectAtIndex:rowNum]];
        mLargestWinReel = pReel;
  return  ( mAlive = TRUE);
        
    }
   
    NSNumber *slotNum = [pSlotReel objectAtIndex:rowNum];

    
    if (!mAlive) {
        [mThisPlayState replaceObjectAtIndex:pReel withObject:slotNum];

        return mAlive;
    }
    
//    NSInteger preVReelRowNum = [mPattern objectAtIndex:(pReel -1)];
    
    NSNumber *prevReelSymbol = nil; //[mThisPlayState objectAtIndex:(pReel -1)];
    
    for (int y = (pReel-1); y>=0; y--) {
    prevReelSymbol = [mThisPlayState objectAtIndex:y];
        
//        if (![prevReelSymbol isEqualToNumber: [NSNumber numberWithInt:(mWild)]]) {
//            mWinSymbol = [prevReelSymbol integerValue];
//            break;
//        }
        
        if (![self behavesAsWild:prevReelSymbol]) {
            mWinSymbol = [prevReelSymbol integerValue];
            break;
        }
        
        
    }

//    if ([prevReelSymbol isEqualToNumber: [NSNumber numberWithInt:(mWild)]]) 

    if ([self behavesAsWild:prevReelSymbol])
        {
        prevReelSymbol = slotNum;
        mWinSymbol = [prevReelSymbol integerValue];

    }
    
//    if ([slotNum isEqualToNumber:prevReelSymbol] || [slotNum  isEqualToNumber:[NSNumber numberWithInt:(mWild)]] ) {

    if ([slotNum isEqualToNumber:prevReelSymbol] || [self behavesAsWild:slotNum] ) {

        [mThisPlayState replaceObjectAtIndex:pReel withObject:slotNum];
        mLargestWinReel = pReel;

        return  ( mAlive = TRUE);
    }
    
    [mThisPlayState replaceObjectAtIndex:pReel withObject:slotNum];
    return (mAlive=false);

}
+(NSInteger)winTimeForSymbol:(NSInteger)mWinSymbol
{
    NSString *name = [[NSString alloc] initWithCString:symbolAnimarray[mWinSymbol] encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *avlDic = [[AppHelper appDelegate] mAvl];
    
    NSMutableDictionary * scene = [[avlDic objectForKey:@"Animation"] objectForKey:[name autorelease]];
    
    
    NSInteger end = [[scene objectForKey:@"EndIndex"] integerValue]; 
    
    return  (end+90)/30;
}

-(NSInteger)winAnimationTime
{

    if (symbolWins[mWinSymbol][mLargestWinReel] ==0) {
        return 0;
    }
        NSString *name = [[NSString alloc] initWithCString:symbolAnimarray[mWinSymbol] encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *avlDic = [[AppHelper appDelegate] mAvl];
    
    NSMutableDictionary * scene = [[avlDic objectForKey:@"Animation"] objectForKey:[name autorelease]];

    
    NSInteger end = [[scene objectForKey:@"EndIndex"] integerValue]; 
    
    return  (end+90)/30;
    
    
}
-(NSInteger)winAmount
{

    return   symbolWins[mWinSymbol][mLargestWinReel] *(mScatterDetected?mScatterMult:1)*(mWildDetected?mWildMult:1) ;
}
-(void)dealloc
{
    self.mDelegate = nil;
    [mTimer release];
    [mThisPlayState release];
    [mPattern release];
    [super dealloc];
}

@end
