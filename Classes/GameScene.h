//
//  GameScene.h
//  WhatsNext
//
//  Created by Wang43 on 8/27/15.
//
//

#ifndef __WhatsNext__GameScene__
#define __WhatsNext__GameScene__

#include "cocos2d.h"
#include "GameLayer.h"

USING_NS_CC;

class GameScene : public cocos2d::Scene{
public:
    static cocos2d::Scene* create();
private:
    static Scene* gameScene;
    static GameLayer* gameLayer;
};

#endif /* defined(__WhatsNext__GameScene__) */
