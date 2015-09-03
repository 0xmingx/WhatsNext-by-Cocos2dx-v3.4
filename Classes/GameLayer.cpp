//
//  GameLayer.cpp
//  WhatsNext
//
//  Created by Wang43 on 8/27/15.
//
//

#include "GameLayer.h"
#include "cocos2d.h"
#include "GameConstants.h"
#include "SuccessLayer.h"
#include "FailLayer.h"
#include "SimpleAudioEngine.h"
USING_NS_CC;
using namespace CocosDenshion;

int AlreadyPass=0;
int sTags[100];
int sTag=100;

int sColorR=0;
int sColorG=0;
int sColorB=0;
int sColorRecord[36];
int sShapeRecord[36];
int timeOutFlag=0;
int touchEndFlag=0;
int best=0;

int cR=0;
int colorCount=0;
int sR=0;
int shapeCount=0;
int resetLocationTimes=0;

int failTimes = 0;

Size visibleSize;
Vec2 origin;
Sprite *background;
Label *bestEver;
Label *now;

bool GameLayer::init(){
    if (!Layer::init())
    {
        return false;
    }
    visibleSize = Director::getInstance()->getVisibleSize();
    origin = Director::getInstance()->getVisibleOrigin();
    
    AlreadyPass=0;
    sTag=100;
    memset(sTags, 0, 100);
    memset(sColorRecord, 0, 60);
    sColorR=0;
    sColorG=0;
    sColorB=0;
    timeOutFlag=0;
    touchEndFlag=0;
    best=0;
    cR=0;
    colorCount=0;
    sR=0;
    shapeCount=0;
    resetLocationTimes=0;
    
    background = Sprite::create("pics/background.png");
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
    //timer
    pTime = 6.0;
    label = Label::create();
    label->setScale(1.5);
    label->setPosition(Vec2(visibleSize.width/2 + origin.x, visibleSize.height*0.95 + origin.y));
    this->addChild(label);
    
    //bestLabel
    bestEver = Label::create();
    bestEver->setPosition(Vec2(visibleSize.width*0.16 + origin.x, visibleSize.height*0.94 + origin.y));
    bestEver->setBMFontFilePath("fonts/fon.fnt", Vec2::ZERO);
    bestEver->setScale(0.8);
    this->addChild(bestEver);
    
    //nowLabel
    now = Label::create();
    now->setPosition(Vec2(visibleSize.width*0.84 + origin.x, visibleSize.height*0.94 + origin.y));
    now->setBMFontFilePath("fonts/fon.fnt", Vec2::ZERO);
    now->setScale(0.8);
    this->addChild(now);
    
    ads_banner->hideAds(AD_TYPE_BANNER,1);
    
    createNext(visibleSize, origin);
    gaming();
    schedule(schedule_selector(GameLayer::update));
    return true;
}

void GameLayer::update(float t){
    if (!CStoken) {
        if (UserDefault::getInstance()->getBoolForKey("Pro")) {
            best = UserDefault::getInstance()->getIntegerForKey("colorPBest");
        }else{
            best = UserDefault::getInstance()->getIntegerForKey("colorUBest");
        }
    }else{
        if (UserDefault::getInstance()->getBoolForKey("Pro")) {
            best = UserDefault::getInstance()->getIntegerForKey("shapePBest");
        }else{
            best = UserDefault::getInstance()->getIntegerForKey("shapeUBest");
        }
    }
    timeOutFlag = 0;
    if(background->getChildrenCount() <= AlreadyPass){
        createNext(visibleSize,origin);
        pTime = 6.0;
    }
    
    if (pTime > 1.1) {
        pTime -= t;
    }else{
        pTime=0;
        unschedule(schedule_selector(GameLayer::update));
        timeOutFlag=1;
        this->schedule(schedule_selector(GameLayer::failCall),0.2,0,0.6);
    }
    char* mtime = new char[10];
    label->setBMFontFilePath("fonts/fon.fnt", Vec2::ZERO);
    sprintf(mtime,"%d",(int)pTime%60);
    label->setString(mtime);
    //best
    char *bestChar = new char [2];
    if (CH) {
        sprintf(bestChar,"最佳: %d",(int)best);
    }else{
        sprintf(bestChar,"Best: %d",(int)best);
    }
    bestEver->setString(bestChar);
    //now
    char *nowChar = new char [2];
    if (CH) {
        sprintf(nowChar,"当前: %d",(int)AlreadyPass+1);
    }else{
        sprintf(nowChar,"Now: %d",(int)AlreadyPass+1);
    }
    now->setString(nowChar);
}

void GameLayer::gaming(){
    
    auto listener1 = EventListenerTouchOneByOne::create();
    listener1->setSwallowTouches(false);
    
    listener1->onTouchBegan = [=](Touch* touch, Event* event){
        if (timeOutFlag==1 or touchEndFlag==1) {
            return false;
        }
        return true;
    };
    listener1->onTouchEnded = [=](Touch* touch, Event* event){
        const char *musicPath;
        switch ((AlreadyPass+1)%6) {
            case 0:
                musicPath="mics/right4.mp3";
                break;
            case 1:
                musicPath="mics/right1.mp3";
                break;
            case 2:
                musicPath="mics/right1.mp3";
                break;
            case 3:
                musicPath="mics/right2.mp3";
                break;
            case 4:
                musicPath="mics/right3.mp3";
                break;
            case 5:
                musicPath="mics/right4.mp3";
                break;
                
            default:
                musicPath="mics/right1.mp3";
                break;
        }
        Vec2 touchLo = background->convertToNodeSpace(touch->getLocation());
        //right one
        auto correctSprite=background->getChildByTag(sTags[AlreadyPass]);
        //right one pressed
        if (correctSprite->boundingBox().containsPoint(touchLo)) {
            
            ActionInterval * scaleBy = ScaleBy::create(0.2, 1.4);
            ActionInterval * scaleByRe = scaleBy->reverse();
            Action *sScale = CCSequence::create(scaleBy, scaleByRe, NULL);
            correctSprite->runAction(sScale);
            touchEndFlag=1;//can't touch more
            SimpleAudioEngine::getInstance()->playEffect(musicPath);
            this->schedule(schedule_selector(GameLayer::successCall),0.2,0,0.6);
            goto skip;
        }
        //wrong one
        for (int sCount=0; sCount < AlreadyPass; sCount++) {
            auto failTouchSprite=background->getChildByTag(sTags[sCount]);
            if (failTouchSprite->boundingBox().containsPoint(touchLo)){
                ActionInterval *jumpBy = JumpBy ::create(0.25, Vec2(0, 0), 60, 1);
                ActionInterval *jumpByRe= jumpBy->reverse();
                Action *sJump = CCSequence::create(jumpBy, jumpByRe, NULL);
                correctSprite->runAction(sJump);
                touchEndFlag=1;
                SimpleAudioEngine::getInstance()->playEffect("mics/wrong.mp3");
                this->schedule(schedule_selector(GameLayer::failCall),0.2,0,0.6);
            }
        }
    skip:;
    };
    
    listener1->onTouchCancelled=[=](Touch* touch, Event* event){
        const char *musicPath;
        switch ((AlreadyPass+1)%6) {
            case 0:
                musicPath="mics/right4.mp3";
                break;
            case 1:
                musicPath="mics/right1.mp3";
                break;
            case 2:
                musicPath="mics/right1.mp3";
                break;
            case 3:
                musicPath="mics/right2.mp3";
                break;
            case 4:
                musicPath="mics/right3.mp3";
                break;
            case 5:
                musicPath="mics/right4.mp3";
                break;
                
            default:
                musicPath="mics/right1.mp3";
                break;
        }
        Vec2 touchLo = background->convertToNodeSpace(touch->getLocation());
        
        auto correctSprite=background->getChildByTag(sTags[AlreadyPass]);
       
        if (correctSprite->boundingBox().containsPoint(touchLo)) {
            ActionInterval * scaleBy = ScaleBy::create(0.2, 1.4);
            ActionInterval * scaleByRe = scaleBy->reverse();
            Action *sScale = CCSequence::create(scaleBy, scaleByRe, NULL);
            correctSprite->runAction(sScale);
            touchEndFlag=1;
            SimpleAudioEngine::getInstance()->playEffect(musicPath);
            this->schedule(schedule_selector(GameLayer::successCall),0.2,0,0.6);
            goto skip;
        }
        
        for (int sCount=0; sCount < AlreadyPass; sCount++) {
            auto failTouchSprite=background->getChildByTag(sTags[sCount]);
            if (failTouchSprite->boundingBox().containsPoint(touchLo)){
                ActionInterval *jumpBy = JumpBy ::create(0.25, Vec2(0, 0), 60, 1);
                ActionInterval *jumpByRe= jumpBy->reverse();
                Action *sJump = CCSequence::create(jumpBy, jumpByRe, NULL);
                correctSprite->runAction(sJump);
                touchEndFlag=1;
                SimpleAudioEngine::getInstance()->playEffect("mics/wrong.mp3");
                this->schedule(schedule_selector(GameLayer::failCall),0.2,0,0.6);
            }
        }
    skip:;
    };
    _eventDispatcher->addEventListenerWithSceneGraphPriority(listener1, background);
}
//need refactoring LOL
bool GameLayer::createNext(Size visibleSize, Vec2 origin){
    Sprite *sp;
    auto plistInfo = FileUtils::getInstance()->getValueMapFromFile("GameDefault.plist");
    resetLocationTimes=0;
    
    //rand seed
    timeval psv;
    gettimeofday(&psv, NULL);
    unsigned int rand_seed = psv.tv_usec/1000;
    srand(rand_seed);
    
    //Color-Shape mode
    if (!CStoken) {
        sp = Sprite::create("pics/c.png");
    }else{
        if (UserDefault::getInstance()->getIntegerForKey("Pro")) {
            if (AlreadyPass == 0) {
                sR = rand()%9+1;
            }
            log("sr=%d",sR);
            char* shapex = new char[7];
            sprintf(shapex,"shape%d",(int)sR);
            ValueMap& shapeInfo = plistInfo["shapes"].asValueMap();
            std::string shapePic = shapeInfo[shapex].asString();
            sp = Sprite::create(shapePic);
        }else{
        sShape:int s=rand()%9+1;
            
            if (AlreadyPass%9 == 0){
                memset(sShapeRecord, 0, 36);
            }
            for (int ssCount=0; ssCount<10; ssCount++) {
                if (s == sShapeRecord[ssCount]) {
                    log("shapeReset");
                    goto sShape;
                }
            }
            log("s=%d",s);
            char* shapex = new char[7];
            sprintf(shapex,"shape%d",(int)s);
            ValueMap& shapeInfo = plistInfo["shapes"].asValueMap();
            std::string shapePic = shapeInfo[shapex].asString();
            sp = Sprite::create(shapePic);
            sShapeRecord[AlreadyPass]=s;
        }
    }
    
    //location
sLocation:int x = rand()%600;
    int y = rand()%1024;
    sp->setPosition(Vec2(x+75, y+155));
    log("xpiont:x=%d,y=%d",x+75,y+155);
    //log("x=%d,y=%d",x,y);
    for (int sCount=0; sCount < 100; sCount++) {
        if (sTags[sCount]!=0) {
            if (background->getChildByTag(sTags[sCount])->boundingBox().intersectsRect(sp->boundingBox())){
                resetLocationTimes+=1;
                if (resetLocationTimes>99) {
                    timeOutFlag=1;
                    touchEndFlag=1;
                    this->schedule(schedule_selector(GameLayer::successCall),0.2,0,0.6);
                }else{
                    goto sLocation;
                }
            }
        }
    }
    //colorful
sColorful:int c = rand()%35+1;
    if (AlreadyPass%35 == 0){
        memset(sColorRecord, 0, 36);
    }
    //log("z1=%d",z);
    char* colorx = new char[7];
    sprintf(colorx,"color%d",(int)c);
    for (int scCount=0; scCount<36; scCount++) {
        if (c == sColorRecord[scCount]) {
            log("colorReset");
            goto sColorful;
        }
    }
    //read color
    ValueMap& colorInfo = plistInfo["colors"].asValueMap();
    ValueVector& colorArr = colorInfo[colorx].asValueVector();
    
    if (UserDefault::getInstance()->getIntegerForKey("Pro")) {
        if (AlreadyPass == 0) {
            cR = rand()%5;
        }
        switch (cR) {
            case 0:{
                if (AlreadyPass%9==0) {
                    colorCount=0;
                }else{
                    colorCount+=1;
                }
                sColorR=255;
                sColorG=180+colorCount*3;
                sColorB=180+colorCount*3;
            }
                break;
            case 1:{
                if (AlreadyPass%9==0) {
                    colorCount=0;
                }else{
                    colorCount+=1;
                }
                sColorR=180+colorCount*3;
                sColorG=180+colorCount*3;
                sColorB=255;
            }
                break;
            case 2:{
                if (AlreadyPass%9==0) {
                    colorCount=0;
                }else{
                    colorCount+=1;
                }
                sColorR=180+colorCount*3;
                sColorG=255;
                sColorB=180+colorCount*3;
            }
                break;
            case 3:{
                if (AlreadyPass%9==0) {
                    colorCount=0;
                }else{
                    colorCount+=1;
                }
                sColorR=255;
                sColorG=255;
                sColorB=180+colorCount*3;
            }
                break;
            case 4:{
                if (AlreadyPass%9==0) {
                    colorCount=0;
                }else{
                    colorCount+=1;
                }
                sColorR=180+colorCount*3;
                sColorG=255;
                sColorB=255;
            }
                break;
            case 5:{
                if (AlreadyPass%9==0) {
                    colorCount=0;
                }else{
                    colorCount+=1;
                }
                sColorR=255;
                sColorG=180+colorCount*3;
                sColorB=255;
            }
                break;
            default:
                break;
        }
    }else{
        sColorR=colorArr[0].asInt();
        sColorG=colorArr[1].asInt();
        sColorB=colorArr[2].asInt();
    }
    
    sp->setTag(sTag);
    if (!CStoken) {
        sp->setColor(Color3B(sColorR,sColorG,sColorB));
    }
    if (Director::getInstance()->getOpenGLView()->getFrameSize().height == 1024 or Director::getInstance()->getOpenGLView()->getFrameSize().height == 2048) {
        sp->setScaleX(0.75);
    }
    if (Director::getInstance()->getOpenGLView()->getFrameSize().height == 960 or Director::getInstance()->getOpenGLView()->getFrameSize().height == 480) {
        sp->setScaleX(0.85);
    }
    background->addChild(sp);
    sTags[AlreadyPass]=sTag;
    sColorRecord[AlreadyPass]=c;
    sTag+=1;
    return true;
}

void GameLayer::successCall(float t){
    log("success");
    auto gmLayer = Director::getInstance()->getRunningScene()->getChildByTag(888);
    gmLayer->onExit();
    touchEndFlag=0;
    //Director::getInstance()->pause();
    auto sc = Director::getInstance()->getRunningScene();
    SuccessLayer *successLayer = SuccessLayer::create();
    successLayer->setTag(880);
    sc->addChild(successLayer);
}

void GameLayer::failCall(float t){
    failTimes+=1;//
    log("failed");
    SimpleAudioEngine::getInstance()->playEffect("mics/fail.mp3");
    auto gmLayer = Director::getInstance()->getRunningScene()->getChildByTag(888);
    gmLayer->onExit();
    touchEndFlag=0;
    //Director::getInstance()->pause();
    auto sc = Director::getInstance()->getRunningScene();
    FailLayer *failLayer = FailLayer::create();
    failLayer->setTag(881);
    sc->addChild(failLayer);
}