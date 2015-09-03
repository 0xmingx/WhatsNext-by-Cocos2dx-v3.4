
#include "AppDelegate.h"
#include "WelcomeScene.h"
#import "GameKitHelper.h"
#include "Ads.h"
#include "GameConstants.h"
USING_NS_CC;

AgentManager* agent;
AdsListener* listener1;
AdsListener* listener2;
ProtocolAds* ads_banner;
ProtocolAds* ads_slide;

AppDelegate::AppDelegate() {

}

AppDelegate::~AppDelegate() 
{
}

//if you want a different context,just modify the value of glContextAttrs
//it will takes effect on all platforms
void AppDelegate::initGLContextAttrs()
{
    //set OpenGL context attributions,now can only set six attributions:
    //red,green,blue,alpha,depth,stencil
    GLContextAttrs glContextAttrs = {8, 8, 8, 8, 24, 8};

    GLView::setGLContextAttrs(glContextAttrs);
}

bool AppDelegate::applicationDidFinishLaunching() {
    
    //gamecenter login
    [[GameKitHelper sharedGameKitHelper] authenticateLocalUser];
    
    auto director = Director::getInstance();
    auto glview = director->getOpenGLView();
    
    //screen adaptation
    cocos2d::Size frameSize = glview->getFrameSize();
    cocos2d::Size lsSize = cocos2d::Size(750, 1334);
    float scaleX = (float)frameSize.width/lsSize.width;
    float scaleY = (float)frameSize.height/lsSize.height;
    
    float scale = 0.0f; // MAX(scaleX, scaleY);
    if (scaleX > scaleY) {
        scale = scaleX / (frameSize.height / (float) lsSize.height);
    } else {
        scale = scaleY / (frameSize.width / (float) lsSize.width);
    }
    //log("scale=%f",scale);
    glview->setDesignResolutionSize(lsSize.width * scale, lsSize.height * scale,  ResolutionPolicy::NO_BORDER);

    // turn on display FPS
    director->setDisplayStats(false);

    // set FPS. the default value is 1.0/60 if you don't call this
    director->setAnimationInterval(1.0 / 60);
    
    //ads from anysdk
    agent = AgentManager::getInstance();
    std::string appKey = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
    std::string appSecret = "x";
    std::string privateKey = "x";
    std::string oauthLoginServer = "http://oauth.anysdk.com/api/OauthLoginDemo/Login.php";
    //init agent
    agent->init(appKey, appSecret, privateKey, oauthLoginServer);
    //load plugins
    agent->loadAllPlugins();
    //preload ads
    listener1 = new Ads();
    if(AgentManager::getInstance()->getAdsPlugin())
    {
        AgentManager::getInstance()->getAdsPlugin()->setAdsListener(listener1);
    }
    ads_banner = AgentManager::getInstance()->getAdsPlugin();
    ads_banner->hideAds(AD_TYPE_BANNER,1);
    
    ads_slide = AgentManager::getInstance()->getAdsPlugin();
    ads_slide->preloadAds(AD_TYPE_FULLSCREEN,1);
    
    //userDefault init
    if(!UserDefault::getInstance()->getBoolForKey("isExit", false))
    {
        UserDefault::getInstance()->setBoolForKey("isExit", true);
        UserDefault::getInstance()->setBoolForKey("Music", true);
        //UserDefault::getInstance()->setBoolForKey("NoAD", false);
        UserDefault::getInstance()->setBoolForKey("Pro", false);
        UserDefault::getInstance()->setIntegerForKey("colorUBest", 0);
        UserDefault::getInstance()->setIntegerForKey("shapeUBest", 0);
        UserDefault::getInstance()->setIntegerForKey("colorPBest", 0);
        UserDefault::getInstance()->setIntegerForKey("shapePBest", 0);
        //if XMl isn't exit, creat a new one.
        UserDefault::getInstance()->flush();
    }
    
    // create a scene. it's an autorelease object
    auto scene = WelcomeScene::create();
    
    // run
    director->runWithScene(scene);

    return true;
}

// This function will be called when the app is inactive. When comes a phone call,it's be invoked too
void AppDelegate::applicationDidEnterBackground() {
    Director::getInstance()->stopAnimation();

    // if you use SimpleAudioEngine, it must be pause
    // SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground() {
    Director::getInstance()->startAnimation();

    // if you use SimpleAudioEngine, it must resume here
    // SimpleAudioEngine::getInstance()->resumeBackgroundMusic();
}
