//
//  BXChara2DSpec.h
//  Karakuri Box
//
//  Created by numata on 10/02/28.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "BXResourceElement.h"
#import "BXChara2DState.h"
#import "BXChara2DImage.h"


@interface BXChara2DSpec : BXResourceElement {
    NSMutableArray*     mStates;

    NSMutableArray*     mImages;
    
    double              mKomaPreviewScale;
}

- (id)initWithName:(NSString*)name defaultState:(BOOL)hasDefaultState;

- (BXChara2DState*)addNewState;
- (int)stateCount;
- (BXChara2DState*)stateAtIndex:(int)index;
- (BXChara2DState*)stateWithID:(int)stateID;
- (void)removeState:(BXChara2DState*)theState;
- (void)sortStateList;
- (void)changeStateIDInAllKomaFrom:(int)oldStateID to:(int)newStateID;

- (BXChara2DImage*)addImageAtPath:(NSString*)path document:(BXDocument*)document;
- (int)imageCount;
- (BXChara2DImage*)imageAtIndex:(int)index;
- (BXChara2DImage*)imageWithID:(int)imageID;

- (double)komaPreviewScale;
- (void)setKomaPreviewScale:(double)value;

- (void)preparePreviewTextures;

@end
