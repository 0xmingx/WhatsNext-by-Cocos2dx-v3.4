//
//  Ads.h
//  WhatsNext
//
//  Created by Wang43 on 8/31/15.
//
//

#ifndef __WhatsNext__Ads__
#define __WhatsNext__Ads__
#include "AgentManager.h"
using namespace anysdk::framework;

class Ads : public AdsListener{
public:
    virtual void  onAdsResult(AdsResultCode code, const char* msg);
};

#endif /* defined(__WhatsNext__Ads__) */
