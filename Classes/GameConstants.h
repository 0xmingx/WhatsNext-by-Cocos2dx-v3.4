//
//  GameConstants.h
//  WhatsNext
//
//  Created by Wang43 on 8/27/15.
//
//

#ifndef __WhatsNext__GameConstants__
#define __WhatsNext__GameConstants__
#include "AgentManager.h"
using namespace anysdk::framework;

extern int AlreadyPass;//users mission count
//extern int timeOutFlag;//time out, not using
extern bool CStoken;//color or shape(animals) mode
extern int level;//title

extern int resetLocationTimes;//if 999, win
extern bool CH;//get users languages
extern int failTimes;//if 5, play ads

//ads
extern AgentManager* agent;
extern AdsListener* listener1;
extern AdsListener* listener2;
extern ProtocolAds* ads_banner;
extern ProtocolAds* ads_slide;

extern bool noAdBought;


#endif /* defined(__WhatsNext__GameConstants__) */
