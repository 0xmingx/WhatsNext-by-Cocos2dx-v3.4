//
//  Ads.cpp
//  WhatsNext
//
//  Created by Wang43 on 8/31/15.
//
//

#include "Ads.h"
USING_NS_CC;
void Ads::onAdsResult(AdsResultCode code, const char* msg){
    log("OnAdsResult, code : %d, msg : %s", code, msg);
    //listener for ads
    switch (code) {
        case 1:{
            auto gmLayer = Director::getInstance()->getRunningScene();//->getChildByTag(888);
            gmLayer->onExit();
        }
            break;
        case 2:{
            auto gmLayer = Director::getInstance()->getRunningScene();//->getChildByTag(888);
            gmLayer->onEnter();
        }
            break;
            
        default:
            break;
    }
    
}