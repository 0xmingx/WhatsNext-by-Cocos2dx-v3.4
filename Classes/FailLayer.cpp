//
//  FailLayer.cpp
//  WhatsNext
//
//  Created by Wang43 on 8/27/15.
//
//

#include "FailLayer.h"
#include "GameScene.h"
#include "WelcomeScene.h"
#include "GameConstants.h"
#include "SimpleAudioEngine.h"
USING_NS_CC;
using namespace CocosDenshion;


bool FailLayer::init()
{
    if (!Layer::init())
    {
        return false;
    }
    std::string failWords[12]={
        "Wow, perhaps you need to concentrate.",
        "Wow, perhaps you need to concentrate.",
        "Hum, you just reached the average level.",
        "Oh! great job!",
        "Wow! Can't imagine you did this!",
        "Excellent!",
        "Unbelievable! Very few people can reach this.",
        "Incredible! You exceeded the programmer.",
        "Amazing! Only 2% people could get this.",
        "My Honer! Immortal Master!",
        "Are you came from the outer space?",
        "......Must be a BUG!!"};
    std::string title[12]={"None", "Slowpoke", "Normal", "Professional", "Earl", "Master", "Duke", "Great Master", "Legendary", "Immortal", "FromMARS", "BUG!"};
    std::string fontPath="fonts/fon.fnt";
    //std::string timeOut="Time Out! ";
    //std::string wrongOne="Wrong One! ";
    std::string yourTitle="This Time's Title: ";
    //localization for chinese
    if (CH) {
        failWords[0]="呵呵，是否经常忘记东西放哪儿了？";
        failWords[1]="呵呵，是否经常忘记东西放哪儿了？";
        failWords[2]="嗯，正常人的水准";
        failWords[3]="还不错哟！";
        failWords[4]="没想到你还能到这里！";
        failWords[5]="牛X！";
        failWords[6]="太牛X！很少有人打到这里";
        failWords[7]="天啦噜，你的等级已经超过开发者的了";
        failWords[8]="作者已经被吓尿了！只有2%的人能达到这一级";
        failWords[9]="作者的女朋友问他为什么跪着敲代码...";
        failWords[10]="不可能！你该不会是外星来的吧！？";
        failWords[11]="......这一定是个Bug!!";
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
        //timeOut="时间到！";
        //wrongOne="点错啦！";
        yourTitle="本次称号：";
    }
    std::string restartNormalType;
    std::string restartPressedType;
    std::string menuNormalType;
    std::string menuPressedType;
    if (CH) {
        restartNormalType="pics/Ch/restartNormal.png";
        restartPressedType="pics/Ch/restartPressed.png";
        menuNormalType="pics/Ch/menuNormal.png";
        menuPressedType="pics/Ch/menuPressed.png";
    }else{
        restartNormalType="pics/En/restartNormal.png";
        restartPressedType="pics/En/restartPressed.png";
        menuNormalType="pics/En/menuNormal.png";
        menuPressedType="pics/En/menuPressed.png";
    }
    
    int level=0;
    std::string levelx;
    if (AlreadyPass<6) {
        level=0;
    }else if (AlreadyPass>=6 && AlreadyPass<12){
        level=1;
    }else if (AlreadyPass>=12 && AlreadyPass<18){
        level=2;
    }else if (AlreadyPass>=18 && AlreadyPass<24){
        level=3;
    }else if (AlreadyPass>=24 && AlreadyPass<30){
        level=4;
    }else if (AlreadyPass>=30 && AlreadyPass<36){
        level=5;
    }else if (AlreadyPass>=36 && AlreadyPass<42){
        level=6;
    }else if (AlreadyPass>=42 && AlreadyPass<48){
        level=7;
    }else if (AlreadyPass>=48 && AlreadyPass<54){
        level=8;
    }else if (AlreadyPass>=54 && AlreadyPass<60){
        level=9;
    }else if (AlreadyPass>=60 && AlreadyPass<66){
        level=10;
    }else if (AlreadyPass>=66){
        level=11;
    }
    ads_banner->showAds(AD_TYPE_BANNER,1);
    if (failTimes == 5) {
        ads_banner->hideAds(AD_TYPE_BANNER,1);
        ads_slide = AgentManager::getInstance()->getAdsPlugin();
        ads_slide->showAds(AD_TYPE_FULLSCREEN,1);
        failTimes=0;
    }
    
    Size visibleSize = Director::getInstance()->getVisibleSize();
    Vec2 origin = Director::getInstance()->getVisibleOrigin();
    
    auto background = Sprite::create("pics/background.png");
    background->setPosition(Vec2(visibleSize.width/2 + origin.x, visibleSize.height/2 + origin.y));
    this->addChild(background);
    //background adaptation
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
    
    Label *failLabel = Label::create();
    failLabel->setDimensions(620,300);
    failLabel->setBMFontFilePath(fontPath, Vec2::ZERO);
    failLabel->setPosition(Vec2(visibleSize.width*0.5 + origin.x,visibleSize.height*0.7 + origin.y));
    if (timeOutFlag) {
        failLabel->setString(failWords[level]);
    }else{
        failLabel->setString(failWords[level]);
    }
    failLabel->setHorizontalAlignment(TextHAlignment::CENTER);
    this->addChild(failLabel);
    
    Label *failTitleLabel = Label::create();
    failTitleLabel->setDimensions(620,300);
    failTitleLabel->setBMFontFilePath(fontPath, Vec2::ZERO);
    failTitleLabel->setPosition(Vec2(visibleSize.width*0.5 + origin.x,visibleSize.height*0.48 + origin.y));
    failTitleLabel->setString(yourTitle+title[level]);
    failTitleLabel->setHorizontalAlignment(TextHAlignment::CENTER);
    this->addChild(failTitleLabel);
    
    auto restartItem = MenuItemImage::create(restartNormalType, restartPressedType, CC_CALLBACK_1(FailLayer::failRestartCallBack, this));
    auto menuItem = MenuItemImage::create(menuNormalType, menuPressedType, CC_CALLBACK_1(FailLayer::failBackCallBack, this));
    
    auto failMenu = Menu::create(restartItem, menuItem, NULL);
    failMenu->alignItemsVerticallyWithPadding(60);
    failMenu->setPosition(Vec2(visibleSize.width*0.5 + origin.x,visibleSize.height*0.33 + origin.y));
    this->addChild(failMenu);
    AlreadyPass=0;
    return true;
}

void FailLayer::failRestartCallBack(Ref* pSender){
    this->removeFromParent();
    //Director::getInstance()->resume();
    ads_banner->hideAds(AD_TYPE_BANNER,1);
    Scene *currentScene = Director::getInstance()->getRunningScene();
    Director::getInstance()->pushScene(currentScene);
    Director::getInstance()->popScene();
    
    Scene* resultSceneWithAbout = TransitionFade::create(0.01f, GameScene::create());
    Director::getInstance()->replaceScene(resultSceneWithAbout);
}

void FailLayer::failBackCallBack(Ref *pSender){
    ads_banner->hideAds(AD_TYPE_BANNER,1);
    Scene* resultSceneWithAbout = TransitionFade::create(0.05f, WelcomeScene::create());
    Director::getInstance()->replaceScene(resultSceneWithAbout);
}