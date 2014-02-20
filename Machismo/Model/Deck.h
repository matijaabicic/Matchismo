//
//  Deck.h
//  Machismo
//
//  Created by Matija Abicic on 2/11/14.
//  Copyright (c) 2014 Matija Abicic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

-(void) addCard:(Card *)card atTop:(BOOL)atTop;
-(void) addCard:(Card *)card;
-(Card *) drawRandomCard;

@end
