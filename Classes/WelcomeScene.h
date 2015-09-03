//
//  WelcomeScene.h
//  WhatsNext
//
//  Created by Wang43 on 8/28/15.
//
//

#ifndef __WhatsNext__WelcomeScene__
#define __WhatsNext__WelcomeScene__

#include "cocos2d.h"
#include "WelcomeLayer.h"

USING_NS_CC;

class WelcomeScene : public cocos2d::Scene{
public:
    static cocos2d::Scene* create();
private:
    static Scene* welcomeScene;
    static WelcomeLayer* welcomeLayer;
};

#endif /* defined(__WhatsNext__WelcomeScene__) */
