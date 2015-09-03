//
//  GameLayer.h
//  WhatsNext
//
//  Created by Wang43 on 8/27/15.
//
//

#ifndef __WhatsNext__GameLayer__
#define __WhatsNext__GameLayer__

class GameLayer : public cocos2d::Layer{
public:
    CREATE_FUNC(GameLayer);
private:
    virtual bool init() override;
    bool createNext(cocos2d::Size visibleSize, cocos2d::Vec2 origin);
    void gaming();
    void successCall(float t);
    void failCall(float t);
    void update(float t);
    
    cocos2d::Label *label;
    float pTime;
};
#endif /* defined(__WhatsNext__GameLayer__) */
