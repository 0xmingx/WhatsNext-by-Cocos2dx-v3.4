//
//  WelcomeLayer.h
//  WhatsNext
//
//  Created by Wang43 on 8/28/15.
//
//

#ifndef __WhatsNext__WelcomeLayer__
#define __WhatsNext__WelcomeLayer__

class WelcomeLayer : public cocos2d::Layer{
public:
    CREATE_FUNC(WelcomeLayer);
private:
    virtual bool init() override;
    void colorCallback(Ref* pSender);
    void shapeCallback(Ref* pSender);
    void musicCallback(Ref* pSender);
    void proCallback(Ref* pSender);
    void gameCenterCallback(Ref* pSender);
    //void noAdsCallback(Ref* pSender);
    void update(float t);
};

#endif /* defined(__WhatsNext__WelcomeLayer__) */
