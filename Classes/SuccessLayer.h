//
//  SuccessLayer.h
//  WhatsNext
//
//  Created by Wang43 on 8/27/15.
//
//

#ifndef __WhatsNext__SuccessLayer__
#define __WhatsNext__SuccessLayer__

class SuccessLayer :public cocos2d::Layer{
public:
    CREATE_FUNC(SuccessLayer);
private:
    virtual bool init();
    void successRestartCallBack(Ref* pSender);
    void successBackCallBack(Ref* pSender);
    void delayBack(float t);
    void goOnCallBack(Ref* pSender);
};

#endif /* defined(__WhatsNext__SuccessLayer__) */
