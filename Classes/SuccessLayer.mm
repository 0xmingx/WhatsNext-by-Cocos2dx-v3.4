//
//  SuccessLayer.cpp
//  WhatsNext
//
//  Created by Wang43 on 8/27/15.
//
//
//

#include "SuccessLayer.h"
#include "GameScene.h"
#include "WelcomeScene.h"
#include "GameConstants.h"
#include "GameKitHelper.h"
#include "SimpleAudioEngine.h"
USING_NS_CC;
using namespace CocosDenshion;
int level=0;
bool SuccessLayer::init(){
    if (!Layer::init())
    {
        return false;
    }
    cocos2d::Size visibleSize = Director::getInstance()->getVisibleSize();
    Vec2 origin = Director::getInstance()->getVisibleOrigin();
    std::string title[12]={"None", "Slowpoke", "Normal", "Professional", "Earl", "Master", "Duke", "Great Master", "Legendary", "Immortal", "FromMARS", "BUG!"};
    std::string fontPath="fonts/fon.fnt";
    std::string restartNormalType="pics/En/restartNormal.png";
    std::string restartPressedType="pics/En/restartPressed.png";
    std::string menuNormalType="pics/En/menuNormal.png";
    std::string menuPressedType="pics/En/menuPressed.png";
    std::string goOnNormalType="pics/En/goOnNormal.png";
    std::string goOnPressedType="pics/En/goOnPressed.png";
    std::string cong="  Congratulations!    A new title:";
    std::string guide=" Press the newest one! ";
    if (CH) {
        title[0]="无称号";
        title[1]="天然呆";
        title[2]="凡人";
        title[3]="学霸";
        title[4]="专家";
        title[5]="异士";
        title[6]="大师";
        title[7]="禅";
        title[8]="传奇";
        title[9]="神迹";
        title[10]="外星来客";
        title[11]="霸哥";
        restartNormalType="pics/Ch/restartNormal.png";
        restartPressedType="pics/Ch/restartPressed.png";
        menuNormalType="pics/Ch/menuNormal.png";
        menuPressedType="pics/Ch/menuPressed.png";
        goOnNormalType="pics/Ch/goOnNormal.png";
        goOnPressedType="pics/Ch/goOnPressed.png";
        cong="祝贺你！获得了一个新称号：";
        guide="记得点最新出现的那一个！";
    }
    
    AlreadyPass+=1;
    
    switch (AlreadyPass) {
        case 6:
            level = 1;
            break;
        case 12:
            level = 2;
            break;
        case 18:
            level = 3;
            break;
        case 24:
            level = 4;
            break;
        case 30:
            level = 5;
            break;
        case 36:
            level = 6;
            break;
        case 42:
            level = 7;
            break;
        case 48:
            level = 8;
            break;
        case 54:
            level = 9;
            break;
        case 60:
            level = 10;
            break;
        case 66:
            level = 11;
            break;
        default:
            level = level;
            break;
    }
    //record best
    if (!CStoken) {
        if (UserDefault::getInstance()->getBoolForKey("Pro")) {
            if (AlreadyPass > UserDefault::getInstance()->getIntegerForKey("colorPBest")) {
                UserDefault::getInstance()->setIntegerForKey("colorPBest", AlreadyPass);
                UserDefault::getInstance()->flush();
                //upload game center scores
                [[GameKitHelper sharedGameKitHelper] reportScore: (int64_t) AlreadyPass forCategory: (NSString*) @"WhatsNext01_HSCP"];
            }
        }else{
            if (AlreadyPass > UserDefault::getInstance()->getIntegerForKey("colorUBest")){
                UserDefault::getInstance()->setIntegerForKey("colorUBest", AlreadyPass);
                UserDefault::getInstance()->flush();
                [[GameKitHelper sharedGameKitHelper] reportScore: (int64_t) AlreadyPass forCategory: (NSString*) @"WhatsNext01_HSC"];
            }
        }
    }else{
        if (UserDefault::getInstance()->getBoolForKey("Pro")) {
            if (AlreadyPass > UserDefault::getInstance()->getIntegerForKey("shapePBest")) {
                UserDefault::getInstance()->setIntegerForKey("shapePBest", AlreadyPass);
                UserDefault::getInstance()->flush();
                [[GameKitHelper sharedGameKitHelper] reportScore: (int64_t) AlreadyPass forCategory: (NSString*) @"WhatsNext01_HSAP"];
            }
        }else{
            if (AlreadyPass > UserDefault::getInstance()->getIntegerForKey("shapeUBest")){
                UserDefault::getInstance()->setIntegerForKey("shapeUBest", AlreadyPass);
                UserDefault::getInstance()->flush();
                [[GameKitHelper sharedGameKitHelper] reportScore: (int64_t) AlreadyPass forCategory: (NSString*) @"WhatsNext01_HSA"];
            }
        }
    }
    
    auto background = Sprite::create("pics/background.png");
    background->setPosition(Vec2(visibleSize.width/2 + origin.x, visibleSize.height/2 + origin.y));
    this->addChild(background);

    if ((int)(visibleSize.width + 0.5) != 750 ) {
        float max_width = MAX(visibleSize.width, 750);
        float min_width = MIN(visibleSize.width, 750);
        background->setScaleX(max_width/min_width);
    }
    else{
        float max_width = MAX(visibleSize.height, 1334);
        float min_width = MIN(visibleSize.height, 1334);
        background->setScaleY(max_width/min_width);
    }
    //auto layerColor = LayerColor::create(Color4B(50,50,55,125), visibleSize.width + origin.x, visibleSize.height + origin.y);
    //this->addChild(layerColor);
    Label *successLabel = Label::create();
    successLabel->setDimensions(560,400);
    successLabel->setBMFontFilePath(fontPath, Vec2::ZERO);
    successLabel->setHorizontalAlignment(TextHAlignment::CENTER);
    successLabel->setPosition(Vec2(visibleSize.width*0.5 + origin.x,visibleSize.height*0.4 + origin.y));
    this->addChild(successLabel);
    
    if (resetLocationTimes>99) {
        if (CH) {
            successLabel->setString("天啦噜！没有地方放新的了！牛X！！");
        }else{
            successLabel->setString("Sooooo Amazing!! No Other Space to fill in!");
        }
        successLabel->setPosition(Vec2(visibleSize.width*0.5 + origin.x,visibleSize.height*0.7 + origin.y));
        auto restartItem = MenuItemImage::create(restartNormalType,restartPressedType, CC_CALLBACK_1(SuccessLayer::successRestartCallBack,this));
        auto menuItem = MenuItemImage::create(menuNormalType,menuPressedType, CC_CALLBACK_1(SuccessLayer::successBackCallBack, this));
        auto successMenu = Menu::create(restartItem, menuItem, NULL);
        successMenu->alignItemsVerticallyWithPadding(60);
        successMenu->setPosition(Vec2(visibleSize.width*0.5 + origin.x,visibleSize.height*0.33 + origin.y));
        this->addChild(successMenu);
        
    }else{
        //log("al=%d",AlreadyPass);
        auto goOnItem = MenuItemImage::create(goOnNormalType,goOnPressedType, CC_CALLBACK_1(SuccessLayer::goOnCallBack, this));
        auto goOnMenu = Menu::create(goOnItem, NULL);
        goOnMenu->alignItemsVerticallyWithPadding(60);
        goOnMenu->setPosition(Vec2(visibleSize.width*0.5 + origin.x,visibleSize.height*0.33 + origin.y));
        this->addChild(goOnMenu);
        goOnMenu->setVisible(false);
        if (AlreadyPass%6==0) {
            char *x = new char[3];
            if (CH) {
                sprintf(x,"已完成: %d",(int)AlreadyPass);
            }else{
                sprintf(x,"Passed: %d",(int)AlreadyPass);
            }
            successLabel->setScale(1.5);
            //successLabel->setPosition(Vec2(visibleSize.width*0.5 + origin.x,visibleSize.height*0.64 + origin.y));
            successLabel->setString(x);
            
            Label *successLabel2 = Label::create();
            successLabel2->setDimensions(560,400);
            successLabel2->setBMFontFilePath(fontPath, Vec2::ZERO);
            successLabel2->setPosition(Vec2(visibleSize.width*0.5 + origin.x,visibleSize.height*0.5 + origin.y));
            successLabel2->setHorizontalAlignment(TextHAlignment::CENTER);
            this->addChild(successLabel2);
            successLabel2->setString(title[level]);
            successLabel2->setVisible(false);
            
            if (!CStoken) {
                if (UserDefault::getInstance()->getBoolForKey("Pro")) {
                    if (AlreadyPass == UserDefault::getInstance()->getIntegerForKey("colorPBest")) {
                        successLabel->setScale(1.0);
                        successLabel->setPosition(Vec2(visibleSize.width*0.5 + origin.x,visibleSize.height*0.64 + origin.y));
                        successLabel->setString(cong);
                        successLabel2->setVisible(true);
                        goOnMenu->setVisible(true);
                        SimpleAudioEngine::getInstance()->playEffect("mics/cherr.mp3");
                        //upload achivements
                        NSString *achiveID= [NSString stringWithFormat:@"WhatsNext01_AchiveP_%d",level];
                        [[GameKitHelper sharedGameKitHelper] unlockAchievement:(GKAchievement *)[[GKAchievement alloc] initWithIdentifier: achiveID] percent:(float)100.0];
                        SimpleAudioEngine::getInstance()->playEffect("Mic/canPress.wav");
                    }else{
                        this->schedule(schedule_selector(SuccessLayer::delayBack),0.2,0,0.7);
                    }
                }else{
                    if (AlreadyPass == UserDefault::getInstance()->getIntegerForKey("colorUBest")){
                        successLabel->setScale(1.0);
                        successLabel->setPosition(Vec2(visibleSize.width*0.5 + origin.x,visibleSize.height*0.64 + origin.y));
                        successLabel->setString(cong);
                        successLabel2->setVisible(true);
                        goOnMenu->setVisible(true);
                        SimpleAudioEngine::getInstance()->playEffect("mics/cherr.mp3");
                        //upload achivements
                        NSString *achiveID= [NSString stringWithFormat:@"WhatsNext01_Achive_%d",level];
                        [[GameKitHelper sharedGameKitHelper] unlockAchievement:(GKAchievement *)[[GKAchievement alloc] initWithIdentifier: achiveID] percent:(float)100.0];
                    }else{
                        this->schedule(schedule_selector(SuccessLayer::delayBack),0.2,0,0.7);
                    }
                }
            }else{
                if (UserDefault::getInstance()->getBoolForKey("Pro")) {
                    if (AlreadyPass == UserDefault::getInstance()->getIntegerForKey("shapePBest")) {
                        successLabel->setScale(1.0);
                        successLabel->setPosition(Vec2(visibleSize.width*0.5 + origin.x,visibleSize.height*0.64 + origin.y));
                        successLabel->setString(cong);
                        successLabel2->setVisible(true);
                        goOnMenu->setVisible(true);
                        SimpleAudioEngine::getInstance()->playEffect("mics/cherr.mp3");
                        //upload achivements
                        NSString *achiveID= [NSString stringWithFormat:@"WhatsNext01_AchiveP_%d",level];
                        [[GameKitHelper sharedGameKitHelper] unlockAchievement:(GKAchievement *)[[GKAchievement alloc] initWithIdentifier: achiveID] percent:(float)100.0];
                    }else{
                        this->schedule(schedule_selector(SuccessLayer::delayBack),0.2,0,0.7);
                    }
                }else{
                    if (AlreadyPass == UserDefault::getInstance()->getIntegerForKey("shapeUBest")){
                        successLabel->setScale(1.0);
                        successLabel->setPosition(Vec2(visibleSize.width*0.5 + origin.x,visibleSize.height*0.64 + origin.y));
                        successLabel->setString(cong);
                        successLabel2->setVisible(true);
                        goOnMenu->setVisible(true);
                        SimpleAudioEngine::getInstance()->playEffect("mics/cherr.mp3");
                        //upload achivements
                        NSString *achiveID= [NSString stringWithFormat:@"WhatsNext01_Achive_%d",level];
                        [[GameKitHelper sharedGameKitHelper] unlockAchievement:(GKAchievement *)[[GKAchievement alloc] initWithIdentifier: achiveID] percent:(float)100.0];
                    }else{
                        this->schedule(schedule_selector(SuccessLayer::delayBack),0.2,0,0.7);
                    }
                }
            }
            
        }else{
            if (AlreadyPass == 1) {
                successLabel->setScale(1.0);
                successLabel->setPosition(Vec2(visibleSize.width*0.5 + origin.x,visibleSize.height*0.54 + origin.y));
                successLabel->setString(guide);
            }else{
                char *x = new char[3];
                if (CH) {
                    sprintf(x,"已完成: %d",(int)AlreadyPass);
                }else{
                    sprintf(x,"Passed: %d",(int)AlreadyPass);
                }
                successLabel->setScale(1.5);
                successLabel->setString(x);
            }
            this->schedule(schedule_selector(SuccessLayer::delayBack),0.2,0,0.7);
        }
    }
    
    return true;
}

void SuccessLayer::goOnCallBack(Ref *pSender){
    schedule(schedule_selector(SuccessLayer::delayBack),0.2,0,0.1);
}

void SuccessLayer::delayBack(float t){
    this->removeFromParent();
    auto gmLayer = Director::getInstance()->getRunningScene()->getChildByTag(888);
    gmLayer->onEnter();
}

void SuccessLayer::successRestartCallBack(Ref* pSender){
    this->removeFromParent();
    
    Scene *currentScene = Director::getInstance()->getRunningScene();
    Director::getInstance()->pushScene(currentScene);
    Director::getInstance()->popScene();
    
    Scene* resultSceneWithAbout = TransitionFade::create(0.01f, GameScene::create());
    Director::getInstance()->replaceScene(resultSceneWithAbout);
}

void SuccessLayer::successBackCallBack(Ref* pSender){
    Scene* resultSceneWithAbout = TransitionFade::create(0.05f, WelcomeScene::create());
    Director::getInstance()->replaceScene(resultSceneWithAbout);
}