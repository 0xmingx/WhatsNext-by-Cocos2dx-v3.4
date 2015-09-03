//
//  WelcomeLayer.cpp
//  WhatsNext
//
//  Created by Wang43 on 8/28/15.
//
//

#include "WelcomeLayer.h"
#include "cocos2d.h"
#include "GameScene.h"
#include "GameConstants.h"
#import "GameKitHelper.h"
#include "SimpleAudioEngine.h"
USING_NS_CC;
using namespace CocosDenshion;

bool CStoken=false;
bool music;
bool CH=false;
int colorLevel;
int shapeLevel;
Label *colorLabel;
Label *shapeLabel;
Label *colorTitleLabel;
Label *shapeTitleLabel;
std::string titleEN[12]={"None", "Slowpoke", "Normal", "Professional", "Earl", "Master", "Duke", "Great Master", "Legendary", "Immortal", "FromMARS", "BUG!"};
std::string titleCH[12]={"无称号", "天然呆", "凡人", "学霸", "专家", "异士", "大师", "禅", "传奇", "神迹", "外星来客", "霸哥"};

bool WelcomeLayer::init(){
    if (!Layer::init())
    {
        return false;
    }
    //get user's language
    LanguageType la = CCApplication::getInstance()->getCurrentLanguage();
    if (la == LanguageType::CHINESE) {
        CH=true;
    }else{
        CH=false;
    }
    cocos2d::Size visibleSize = Director::getInstance()->getVisibleSize();
    Vec2 origin = Director::getInstance()->getVisibleOrigin();
    
    bool Pro = UserDefault::getInstance()->getIntegerForKey("Pro");
    
    std::string titleType;
    std::string colorNormalType;
    std::string colorPressedType;
    std::string shapeNormalType;
    std::string shapePressedType;
    std::string labelFile="fonts/fon.fnt";
    std::string proOnNormalType;
    std::string proOnPressedType;
    std::string proOffNormalType;
    std::string proOffPressedType;

    if (CH) {
        titleType="pics/Ch/title.png";
        colorNormalType="pics/Ch/colorNormal.png";
        colorPressedType="pics/Ch/colorPressed.png";
        shapeNormalType="pics/Ch/shapeNormal.png";
        shapePressedType="pics/Ch/shapePressed.png";
        proOnNormalType="pics/Ch/proOnNormal.png";
        proOnPressedType="pics/Ch/proOnPressed.png";
        proOffNormalType="pics/Ch/proOffNormal.png";
        proOffPressedType="pics/Ch/proOffPressed.png";
        
    }else{
        titleType="pics/En/title.png";
        colorNormalType="pics/En/colorNormal.png";
        colorPressedType="pics/En/colorPressed.png";
        shapeNormalType="pics/En/shapeNormal.png";
        shapePressedType="pics/En/shapePressed.png";
        proOnNormalType="pics/En/proOnNormal.png";
        proOnPressedType="pics/En/proOnPressed.png";
        proOffNormalType="pics/En/proOffNormal.png";
        proOffPressedType="pics/En/proOffPressed.png";
    }
    ads_banner->hideAds(AD_TYPE_BANNER,1);
    
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
    auto title = Sprite::create(titleType);
    title->setPosition(Vec2(visibleSize.width/2 + origin.x, visibleSize.height*0.755 + origin.y));
    this->addChild(title);
    
    //color
    auto colorItem = MenuItemImage::create(colorNormalType, colorPressedType, CC_CALLBACK_1(WelcomeLayer::colorCallback, this));
    colorItem->setAnchorPoint(Vec2(0.5,0.5));
    auto colorMenu = Menu::create(colorItem, NULL);
    colorMenu->setPosition(Vec2(visibleSize.width/2 + origin.x, visibleSize.height*0.5 + origin.y));
    this->addChild(colorMenu);
    colorLabel = Label::create();
    colorLabel->setBMFontFilePath(labelFile, Vec2::ZERO);
    colorLabel->setPosition(Vec2(visibleSize.width*0.33 + origin.x,visibleSize.height*0.44 + origin.y));
    colorLabel->setHorizontalAlignment(TextHAlignment::CENTER);
    colorLabel->setScale(0.7);
    this->addChild(colorLabel);
    colorTitleLabel = Label::create();
    colorTitleLabel->setBMFontFilePath(labelFile, Vec2::ZERO);
    colorTitleLabel->setPosition(Vec2(visibleSize.width*0.67 + origin.x,visibleSize.height*0.44 + origin.y));
    colorTitleLabel->setHorizontalAlignment(TextHAlignment::CENTER);
    colorTitleLabel->setScale(0.7);
    this->addChild(colorTitleLabel);
    
    //animals
    auto shapeItem = MenuItemImage::create(shapeNormalType, shapePressedType, CC_CALLBACK_1(WelcomeLayer::shapeCallback, this));
    shapeItem->setAnchorPoint(Vec2(0.5,0.5));
    auto shapeMenu = Menu::create(shapeItem, NULL);
    shapeMenu->setPosition(Vec2(visibleSize.width/2 + origin.x, visibleSize.height*0.38 + origin.y));
    this->addChild(shapeMenu);
    shapeLabel = Label::create();
    shapeLabel->setBMFontFilePath(labelFile, Vec2::ZERO);
    shapeLabel->setPosition(Vec2(visibleSize.width*0.33 + origin.x,visibleSize.height*0.32 + origin.y));
    shapeLabel->setHorizontalAlignment(TextHAlignment::CENTER);
    shapeLabel->setScale(0.7);
    this->addChild(shapeLabel);
    shapeTitleLabel = Label::create();
    shapeTitleLabel->setBMFontFilePath(labelFile, Vec2::ZERO);
    shapeTitleLabel->setPosition(Vec2(visibleSize.width*0.67 + origin.x,visibleSize.height*0.32 + origin.y));
    shapeTitleLabel->setHorizontalAlignment(TextHAlignment::CENTER);
    shapeTitleLabel->setScale(0.7);
    this->addChild(shapeTitleLabel);
    
    //pro
    MenuItemToggle *proToggleItem;
    auto proOnItem = MenuItemImage::create(proOnNormalType, proOnPressedType);
    auto proOffItem = MenuItemImage::create(proOffNormalType, proOffPressedType);
    if (Pro) {
        proToggleItem = MenuItemToggle::createWithCallback(CC_CALLBACK_1(WelcomeLayer::proCallback,this), proOnItem, proOffItem, NULL);
    }else{
        proToggleItem = MenuItemToggle::createWithCallback(CC_CALLBACK_1(WelcomeLayer::proCallback,this), proOffItem, proOnItem, NULL);
    }
    auto proMenu = Menu::create(proToggleItem, NULL);
    proMenu->setPosition(Vec2(visibleSize.width/2 + origin.x, visibleSize.height*0.26 + origin.y));
    this->addChild(proMenu);
    
    //mic
    music = UserDefault::getInstance()->getBoolForKey("Music");
    MenuItemToggle *musicToggleItem;
    auto musicOnItem = MenuItemImage::create("pics/micOnNormal.png", "pics/micOnPressed.png");
    auto musicOffItem = MenuItemImage::create("pics/micOffNormal.png", "pics/micOffPressed.png");
    if (music) {
        musicToggleItem = MenuItemToggle::createWithCallback(CC_CALLBACK_1(WelcomeLayer::musicCallback,this), musicOnItem,musicOffItem, NULL);
        SimpleAudioEngine::getInstance()->setEffectsVolume(2.0);
        log("oncre");
    }else{
        musicToggleItem = MenuItemToggle::createWithCallback(CC_CALLBACK_1(WelcomeLayer::musicCallback,this), musicOffItem,musicOnItem, NULL);
        SimpleAudioEngine::getInstance()->setEffectsVolume(0.0);
        log("offffcre");
    }
    auto music = Menu::create(musicToggleItem,NULL);
    music->setPosition(Vec2(visibleSize.width*0.65 + origin.x, visibleSize.height*0.16 + origin.y));
    this->addChild(music);
    
    //gameCenter
    auto gameCenterItem = MenuItemImage::create("pics/gameCenterNormal.png", "pics/gameCenterPressed.png", CC_CALLBACK_1(WelcomeLayer::gameCenterCallback, this));
    auto gameCenter = Menu::create(gameCenterItem, NULL);
    gameCenter->setPosition(Vec2(visibleSize.width*0.35 + origin.x, visibleSize.height*0.16 + origin.y));
    this->addChild(gameCenter);
    
    //noAds
    /*auto noAdsItem = MenuItemImage::create("pics/noAdsNormal.png", "pics/noAdsPressed.png", CC_CALLBACK_1(WelcomeLayer::noAdsCallback, this));
    auto noAdsMenu = Menu::create(noAdsItem, NULL);
    noAdsMenu->setPosition(Vec2(visibleSize.width*0.35 + origin.x, visibleSize.height*0.16 + origin.y));
    this->addChild(noAdsMenu);*/
    
    schedule(schedule_selector(WelcomeLayer::update));
    
    return true;
}
//need refactoring LOL
void WelcomeLayer::update(float t){
    bool Pro = UserDefault::getInstance()->getIntegerForKey("Pro");
    char* colorBest = new char[7];
    if (Pro) {
        if (CH) {
            sprintf(colorBest,"最佳: %d",(int)UserDefault::getInstance()->getIntegerForKey("colorPBest"));
        }else{
            sprintf(colorBest,"best: %d",(int)UserDefault::getInstance()->getIntegerForKey("colorPBest"));
        }
    }else{
        if (CH) {
            sprintf(colorBest,"最佳: %d",(int)UserDefault::getInstance()->getIntegerForKey("colorUBest"));
        }else{
            sprintf(colorBest,"best: %d",(int)UserDefault::getInstance()->getIntegerForKey("colorUBest"));
        }
    }
    colorLabel->setString(colorBest);
    [[UIApplication sharedApplication] setStatusBarOrientation: UIInterfaceOrientationPortrait animated: NO];
    char* shapeBest = new char[7];
    if (Pro) {
        if (CH) {
            sprintf(shapeBest,"最佳: %d",(int)UserDefault::getInstance()->getIntegerForKey("shapePBest"));
        }else{
            sprintf(shapeBest,"best: %d",(int)UserDefault::getInstance()->getIntegerForKey("shapePBest"));
        }
    }else{
        if (CH) {
            sprintf(shapeBest,"最佳: %d",(int)UserDefault::getInstance()->getIntegerForKey("shapeUBest"));
        }else{
            sprintf(shapeBest,"best: %d",(int)UserDefault::getInstance()->getIntegerForKey("shapeUBest"));
        }
    }
    shapeLabel->setString(shapeBest);
    
    if (Pro) {
        if (UserDefault::getInstance()->getIntegerForKey("colorPBest")<6) {
            colorLevel=0;
        }else if (UserDefault::getInstance()->getIntegerForKey("colorPBest")>=6 && UserDefault::getInstance()->getIntegerForKey("colorPBest")<12){
            colorLevel=1;
        }else if (UserDefault::getInstance()->getIntegerForKey("colorPBest")>=12 && UserDefault::getInstance()->getIntegerForKey("colorPBest")<18){
            colorLevel=2;
        }else if (UserDefault::getInstance()->getIntegerForKey("colorPBest")>=18 && UserDefault::getInstance()->getIntegerForKey("colorPBest")<24){
            colorLevel=3;
        }else if (UserDefault::getInstance()->getIntegerForKey("colorPBest")>=24 && UserDefault::getInstance()->getIntegerForKey("colorPBest")<30){
            colorLevel=4;
        }else if (UserDefault::getInstance()->getIntegerForKey("colorPBest")>=30 && UserDefault::getInstance()->getIntegerForKey("colorPBest")<36){
            colorLevel=5;
        }else if (UserDefault::getInstance()->getIntegerForKey("colorPBest")>=36 && UserDefault::getInstance()->getIntegerForKey("colorPBest")<42){
            colorLevel=6;
        }else if (UserDefault::getInstance()->getIntegerForKey("colorPBest")>=42 && UserDefault::getInstance()->getIntegerForKey("colorPBest")<48){
            colorLevel=7;
        }else if (UserDefault::getInstance()->getIntegerForKey("colorPBest")>=48 && UserDefault::getInstance()->getIntegerForKey("colorPBest")<54){
            colorLevel=8;
        }else if (UserDefault::getInstance()->getIntegerForKey("colorPBest")>=54 && UserDefault::getInstance()->getIntegerForKey("colorPBest")<60){
            colorLevel=9;
        }else if (UserDefault::getInstance()->getIntegerForKey("colorPBest")>=60 && UserDefault::getInstance()->getIntegerForKey("colorPBest")<66){
            colorLevel=10;
        }else if (UserDefault::getInstance()->getIntegerForKey("colorPBest")>=66){
            colorLevel=11;
        }
        
        if (UserDefault::getInstance()->getIntegerForKey("shapePBest")<6) {
            shapeLevel=0;
        }else if (UserDefault::getInstance()->getIntegerForKey("shapePBest")>=6 && UserDefault::getInstance()->getIntegerForKey("shapePBest")<12){
            shapeLevel=1;
        }else if (UserDefault::getInstance()->getIntegerForKey("shapePBest")>=12 && UserDefault::getInstance()->getIntegerForKey("shapePBest")<18){
            shapeLevel=2;
        }else if (UserDefault::getInstance()->getIntegerForKey("shapePBest")>=18 && UserDefault::getInstance()->getIntegerForKey("shapePBest")<24){
            shapeLevel=3;
        }else if (UserDefault::getInstance()->getIntegerForKey("shapePBest")>=24 && UserDefault::getInstance()->getIntegerForKey("shapePBest")<30){
            shapeLevel=4;
        }else if (UserDefault::getInstance()->getIntegerForKey("shapePBest")>=30 && UserDefault::getInstance()->getIntegerForKey("shapePBest")<36){
            shapeLevel=5;
        }else if (UserDefault::getInstance()->getIntegerForKey("shapePBest")>=36 && UserDefault::getInstance()->getIntegerForKey("shapePBest")<42){
            shapeLevel=6;
        }else if (UserDefault::getInstance()->getIntegerForKey("shapePBest")>=42 && UserDefault::getInstance()->getIntegerForKey("shapePBest")<48){
            shapeLevel=7;
        }else if (UserDefault::getInstance()->getIntegerForKey("shapePBest")>=48 && UserDefault::getInstance()->getIntegerForKey("shapePBest")<54){
            shapeLevel=8;
        }else if (UserDefault::getInstance()->getIntegerForKey("shapePBest")>=54 && UserDefault::getInstance()->getIntegerForKey("shapePBest")<60){
            shapeLevel=9;
        }else if (UserDefault::getInstance()->getIntegerForKey("shapePBest")>=60 && UserDefault::getInstance()->getIntegerForKey("shapePBest")<66){
            shapeLevel=10;
        }else if (UserDefault::getInstance()->getIntegerForKey("shapePBest")>=66){
            shapeLevel=11;
        }
    }else{
        if (UserDefault::getInstance()->getIntegerForKey("colorUBest")<6) {
            colorLevel=0;
        }else if (UserDefault::getInstance()->getIntegerForKey("colorUBest")>=6 && UserDefault::getInstance()->getIntegerForKey("colorUBest")<12){
            colorLevel=1;
        }else if (UserDefault::getInstance()->getIntegerForKey("colorUBest")>=12 && UserDefault::getInstance()->getIntegerForKey("colorUBest")<18){
            colorLevel=2;
        }else if (UserDefault::getInstance()->getIntegerForKey("colorUBest")>=18 && UserDefault::getInstance()->getIntegerForKey("colorUBest")<24){
            colorLevel=3;
        }else if (UserDefault::getInstance()->getIntegerForKey("colorUBest")>=24 && UserDefault::getInstance()->getIntegerForKey("colorUBest")<30){
            colorLevel=4;
        }else if (UserDefault::getInstance()->getIntegerForKey("colorUBest")>=30 && UserDefault::getInstance()->getIntegerForKey("colorUBest")<36){
            colorLevel=5;
        }else if (UserDefault::getInstance()->getIntegerForKey("colorUBest")>=36 && UserDefault::getInstance()->getIntegerForKey("colorUBest")<42){
            colorLevel=6;
        }else if (UserDefault::getInstance()->getIntegerForKey("colorUBest")>=42 && UserDefault::getInstance()->getIntegerForKey("colorUBest")<48){
            colorLevel=7;
        }else if (UserDefault::getInstance()->getIntegerForKey("colorUBest")>=48 && UserDefault::getInstance()->getIntegerForKey("colorUBest")<54){
            colorLevel=8;
        }else if (UserDefault::getInstance()->getIntegerForKey("colorUBest")>=54 && UserDefault::getInstance()->getIntegerForKey("colorUBest")<60){
            colorLevel=9;
        }else if (UserDefault::getInstance()->getIntegerForKey("colorUBest")>=60 && UserDefault::getInstance()->getIntegerForKey("colorUBest")<66){
            colorLevel=10;
        }else if (UserDefault::getInstance()->getIntegerForKey("colorUBest")>=66){
            colorLevel=11;
        }
        
        if (UserDefault::getInstance()->getIntegerForKey("shapeUBest")<6) {
            shapeLevel=0;
        }else if (UserDefault::getInstance()->getIntegerForKey("shapeUBest")>=6 && UserDefault::getInstance()->getIntegerForKey("shapeUBest")<12){
            shapeLevel=1;
        }else if (UserDefault::getInstance()->getIntegerForKey("shapeUBest")>=12 && UserDefault::getInstance()->getIntegerForKey("shapeUBest")<18){
            shapeLevel=2;
        }else if (UserDefault::getInstance()->getIntegerForKey("shapeUBest")>=18 && UserDefault::getInstance()->getIntegerForKey("shapeUBest")<24){
            shapeLevel=3;
        }else if (UserDefault::getInstance()->getIntegerForKey("shapeUBest")>=24 && UserDefault::getInstance()->getIntegerForKey("shapeUBest")<30){
            shapeLevel=4;
        }else if (UserDefault::getInstance()->getIntegerForKey("shapeUBest")>=30 && UserDefault::getInstance()->getIntegerForKey("shapeUBest")<36){
            shapeLevel=5;
        }else if (UserDefault::getInstance()->getIntegerForKey("shapeUBest")>=36 && UserDefault::getInstance()->getIntegerForKey("shapeUBest")<42){
            shapeLevel=6;
        }else if (UserDefault::getInstance()->getIntegerForKey("shapeUBest")>=42 && UserDefault::getInstance()->getIntegerForKey("shapeUBest")<48){
            shapeLevel=7;
        }else if (UserDefault::getInstance()->getIntegerForKey("shapeUBest")>=48 && UserDefault::getInstance()->getIntegerForKey("shapeUBest")<54){
            shapeLevel=8;
        }else if (UserDefault::getInstance()->getIntegerForKey("shapeUBest")>=54 && UserDefault::getInstance()->getIntegerForKey("shapeUBest")<60){
            shapeLevel=9;
        }else if (UserDefault::getInstance()->getIntegerForKey("shapeUBest")>=60 && UserDefault::getInstance()->getIntegerForKey("shapeUBest")<66){
            shapeLevel=10;
        }else if (UserDefault::getInstance()->getIntegerForKey("shapeUBest")>=66){
            shapeLevel=11;
        }
    }
    
    if (CH) {
        colorTitleLabel->setString(titleCH[colorLevel]);
        shapeTitleLabel->setString(titleCH[shapeLevel]);
    }else{
        colorTitleLabel->setString(titleEN[colorLevel]);
        shapeTitleLabel->setString(titleEN[shapeLevel]);
    }
    [[GameKitHelper sharedGameKitHelper] submitAllSavedScores];
}

void WelcomeLayer::colorCallback(Ref* pSender){
    CStoken=false;
    Scene* resultSceneWithSelect = TransitionFade::create(0.05f, GameScene::create());
    Director::getInstance()->pushScene(resultSceneWithSelect);
}

void WelcomeLayer::shapeCallback(Ref* pSender){
    CStoken=true;
    Scene* resultSceneWithSelect = TransitionFade::create(0.05f, GameScene::create());
    Director::getInstance()->pushScene(resultSceneWithSelect);
}

void WelcomeLayer::musicCallback(Ref* pSender){
    bool Music = UserDefault::getInstance()->getIntegerForKey("Music");
    if (Music) {
        log("off");
        SimpleAudioEngine::getInstance()->setEffectsVolume(0.0);
        UserDefault::getInstance()->setBoolForKey("Music", false);
        UserDefault::getInstance()->flush();
    }else{
        log("on");
        SimpleAudioEngine::getInstance()->setEffectsVolume(2.0);
        UserDefault::getInstance()->setBoolForKey("Music", true);
        UserDefault::getInstance()->flush();
    }
}

void WelcomeLayer::proCallback(Ref* pSender){
    bool Pro = UserDefault::getInstance()->getIntegerForKey("Pro");
    if (Pro) {
        UserDefault::getInstance()->setBoolForKey("Pro", false);
        UserDefault::getInstance()->flush();
    }else{
        UserDefault::getInstance()->setBoolForKey("Pro", true);
        UserDefault::getInstance()->flush();
    }
}

void WelcomeLayer::gameCenterCallback(Ref* pSender){
    [[GameKitHelper sharedGameKitHelper] showLeaderboard];
    //log("gameCenter");
}
/*void WelcomeLayer::noAdsCallback(Ref* pSender){
    log("noads");
}*/
