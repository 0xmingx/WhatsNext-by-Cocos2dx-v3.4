//
//  GameScene.cpp
//  WhatsNext
//
//  Created by Wang43 on 8/27/15.
//
//

#include "GameScene.h"

Scene* GameScene::gameScene = nullptr;
GameLayer* GameScene::gameLayer = nullptr;

Scene* GameScene::create() {
    Scene* gameScene = Scene::create();
    
    gameLayer = GameLayer::create();
    gameScene->addChild(gameLayer);
    gameLayer->setTag(888);
    
    return gameScene;
}