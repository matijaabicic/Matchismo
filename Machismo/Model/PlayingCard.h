//
//  PlayingCard.h
//  Machismo
//
//  Created by Matija Abicic on 2/11/14.
//  Copyright (c) 2014 Matija Abicic. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic)   NSString    *suit;
@property (nonatomic) NSUInteger   rank;

+(NSArray *)validSuits;
+(NSArray *)rankStrings;
+(NSUInteger) maxRank;
@end
