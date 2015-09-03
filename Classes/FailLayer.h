//
//  FailLayer.h
//  WhatsNext
//
//  Created by Wang43 on 8/27/15.
//
//

#ifndef __WhatsNext__FailLayer__
#define __WhatsNext__FailLayer__

class FailLayer :public cocos2d::Layer{
public:
    CREATE_FUNC(FailLayer);
private:
    virtual bool init();
    void failRestartCallBack(Ref *pSender);
    void failBackCallBack(Ref *pSender);
    //void failBackToMenuCallBack(Ref *pSender);
    //void failMusicToggleCallback(Ref *pSender);
};

#endif /* defined(__WhatsNext__FailLayer__) */
