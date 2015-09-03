//
//  WelcomeScene.cpp
//  WhatsNext
//
//  Created by Wang43 on 8/28/15.
//
//

#include "WelcomeScene.h"

Scene* WelcomeScene::welcomeScene = nullptr;
WelcomeLayer* WelcomeScene::welcomeLayer = nullptr;

Scene* WelcomeScene::create() {
    Scene* welcomeScene = Scene::create();
    
    welcomeLayer = WelcomeLayer::create();
    welcomeScene->addChild(welcomeLayer);
    
    return welcomeScene;
}