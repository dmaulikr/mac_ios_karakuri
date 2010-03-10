/*!
    @file   KRTexture2DManager
    @author numata
    @date   10/02/17
 */

#include "KRTexture2DManager.h"


KRTexture2DManager*  gKRTex2DMan;


KRTexture2DManager::KRTexture2DManager()
{
    gKRTex2DMan = this;
    
    mNextNewTexID = 0;
}

KRTexture2DManager::~KRTexture2DManager()
{
    // Do nothing
}

int KRTexture2DManager::addTexture(int groupID, const std::string& imageFileName, KRTexture2DScaleMode scaleMode)
{
    return addTexture(groupID, imageFileName, KRVector2DZero, scaleMode);
}

int KRTexture2DManager::addTexture(int groupID, const std::string& imageFileName, const KRVector2D& atlasSize, KRTexture2DScaleMode scaleMode)
{
    int theTexID = mNextNewTexID;
    mNextNewTexID++;
    
    std::vector<int>& theTexIDList = mGroupID_TexIDList_Map[groupID];
    theTexIDList.push_back(theTexID);
    
    mTexID_ImageFileName_Map[theTexID] = imageFileName;
    mTexID_ScaleMode_Map[theTexID] = scaleMode;
    
    setTextureAtlasSize(theTexID, atlasSize);
    
    return theTexID;    
}

int KRTexture2DManager::getResourceSize(int groupID)
{
    int ret = 0;
    
    std::vector<int>& theTexIDList = mGroupID_TexIDList_Map[groupID];
    
    for (std::vector<int>::const_iterator it = theTexIDList.begin(); it != theTexIDList.end(); it++) {
        int texID = *it;
        std::string filename = mTexID_ImageFileName_Map[texID];
        int resourceSize = KRTexture2D::getResourceSize(filename);
        ret += resourceSize;
    }
    
    return ret;
}

void KRTexture2DManager::loadTextureFiles(int groupID, KRWorld* loaderWorld, double minDuration)
{
    std::vector<int>& theTexIDList = mGroupID_TexIDList_Map[groupID];

    int allResourceSize = 0;
    NSTimeInterval sleepTime = 0.2;

    for (std::vector<int>::const_iterator it = theTexIDList.begin(); it != theTexIDList.end(); it++) {
        int texID = *it;
        std::string filename = mTexID_ImageFileName_Map[texID];
        int resourceSize = KRTexture2D::getResourceSize(filename);
        allResourceSize += resourceSize;
    }

    for (std::vector<int>::const_iterator it = theTexIDList.begin(); it != theTexIDList.end(); it++) {
        int texID = *it;
        std::string filename = mTexID_ImageFileName_Map[texID];
        int resourceSize = KRMusic::getResourceSize(filename);
        double theMinDuration = ((double)resourceSize / allResourceSize) * minDuration;
        
        int baseFinishedSize = 0;
        if (loaderWorld != NULL) {
            baseFinishedSize = loaderWorld->_getFinishedSize();
        }
        
        NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
        if (mTexMap[texID] == NULL) {
            KRTexture2DScaleMode scaleMode = mTexID_ScaleMode_Map[texID];
            mTexMap[texID] = new KRTexture2D(filename, scaleMode);
        }
        NSTimeInterval loadTime = [NSDate timeIntervalSinceReferenceDate] - startTime;
        
        double progress = loadTime / theMinDuration;
        if (loaderWorld != NULL) {
            if (progress < 1.0) {
                while (progress < 1.0) {
                    loaderWorld->_setFinishedSize(baseFinishedSize + progress * resourceSize);
                    [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:sleepTime]];
                    loadTime += sleepTime;
                    progress = loadTime / theMinDuration;
                }
            }
            int resourceSize = KRMusic::getResourceSize(filename);
            loaderWorld->_setFinishedSize(baseFinishedSize + resourceSize);
        }
    }
}

void KRTexture2DManager::unloadTextureFiles(int groupID)
{
    // Do nothing
}

KRTexture2D* KRTexture2DManager::_getTexture(int texID)
{
    // IDからテクスチャを引っ張ってくる。
    KRTexture2D* theTex = mTexMap[texID];
    if (theTex == NULL) {
        std::string filename = mTexID_ImageFileName_Map[texID];
        KRTexture2DScaleMode scaleMode = mTexID_ScaleMode_Map[texID];
        theTex = new KRTexture2D(filename, scaleMode);
        mTexMap[texID] = theTex;
    }
    
    // テクスチャが見つからなかったときの処理。
    if (theTex == NULL) {
        const char *errorFormat = "Failed to find the texture with ID %d.";
        if (gKRLanguage == KRLanguageJapanese) {
            errorFormat = "ID が %d のテクスチャは見つかりませんでした。";
        }
        throw KRRuntimeError(errorFormat, texID);
    }

    // リターン
    return theTex;
}

KRVector2D KRTexture2DManager::getTextureSize(int texID)
{
    return _getTexture(texID)->getSize();
}

KRVector2D KRTexture2DManager::getAtlasSize(int texID)
{
    return _getTexture(texID)->getAtlasSize();
}

void KRTexture2DManager::setTextureAtlasSize(int texID, const KRVector2D& size)
{
    _getTexture(texID)->setTextureAtlasSize(size);
}



#pragma mark -
#pragma mark ---- テクスチャの描画 ----

void KRTexture2DManager::drawAtPoint(int texID, const KRVector2D& pos, double alpha)
{
    _getTexture(texID)->drawAtPoint_(pos, KRColor(1, 1, 1, alpha));
}

void KRTexture2DManager::drawAtPoint(int texID, const KRVector2D& pos, const KRColor& color)
{
    _getTexture(texID)->drawAtPoint_(pos, color);
}

void KRTexture2DManager::drawAtPointEx(int texID, const KRVector2D& pos, double rotate, const KRVector2D& origin, const KRVector2D& scale, double alpha)
{
    _getTexture(texID)->drawAtPointEx_(pos, KRRect2DZero, rotate, origin, scale, KRColor(1, 1, 1, alpha));
}

void KRTexture2DManager::drawAtPointEx(int texID, const KRVector2D& pos, double rotate, const KRVector2D& origin, const KRVector2D& scale, const KRColor& color)
{
    _getTexture(texID)->drawAtPointEx_(pos, KRRect2DZero, rotate, origin, scale, color);
}

void KRTexture2DManager::drawAtPointEx2(int texID, const KRVector2D& pos, const KRRect2D& srcRect, double rotate, const KRVector2D& origin, const KRVector2D& scale, double alpha)
{
    _getTexture(texID)->drawAtPointEx_(pos, srcRect, rotate, origin, scale, KRColor(1, 1, 1, alpha));
}

void KRTexture2DManager::drawAtPointEx2(int texID, const KRVector2D& pos, const KRRect2D& srcRect, double rotate, const KRVector2D& origin, const KRVector2D& scale, const KRColor& color)
{
    _getTexture(texID)->drawAtPointEx_(pos, srcRect, rotate, origin, scale, color);
}

void KRTexture2DManager::drawAtPointCenter(int texID, const KRVector2D& centerPos, double alpha)
{
    _getTexture(texID)->drawAtPointCenter_(centerPos, KRColor(1, 1, 1, alpha));
}

void KRTexture2DManager::drawAtPointCenter(int texID, const KRVector2D& centerPos, const KRColor& color)
{
    _getTexture(texID)->drawAtPointCenter_(centerPos, color);
}

void KRTexture2DManager::drawAtPointCenterEx(int texID, const KRVector2D& centerPos, double rotate, const KRVector2D& origin, const KRVector2D& scale, double alpha)
{
    _getTexture(texID)->drawAtPointCenterEx_(centerPos, KRRect2DZero, rotate, origin, scale, KRColor(1, 1, 1, alpha));
}

void KRTexture2DManager::drawAtPointCenterEx(int texID, const KRVector2D& centerPos, double rotate, const KRVector2D& origin, const KRVector2D& scale, const KRColor& color)
{
    _getTexture(texID)->drawAtPointCenterEx_(centerPos, KRRect2DZero, rotate, origin, scale, color);
}

void KRTexture2DManager::drawAtPointCenterEx2(int texID, const KRVector2D& centerPos, const KRRect2D& srcRect, double rotate, const KRVector2D& origin, const KRVector2D& scale, double alpha)
{
    _getTexture(texID)->drawAtPointCenterEx_(centerPos, srcRect, rotate, origin, scale, KRColor(1, 1, 1, alpha));
}

void KRTexture2DManager::drawAtPointCenterEx2(int texID, const KRVector2D& centerPos, const KRRect2D& srcRect, double rotate, const KRVector2D& origin, const KRVector2D& scale, const KRColor& color)
{
    _getTexture(texID)->drawAtPointCenterEx_(centerPos, srcRect, rotate, origin, scale, color);
}

void KRTexture2DManager::drawInRect(int texID, const KRRect2D& destRect, double alpha)
{
    _getTexture(texID)->drawInRect_(destRect, KRColor(1, 1, 1, alpha));
}

void KRTexture2DManager::drawInRect(int texID, const KRRect2D& destRect, const KRColor& color)
{
    _getTexture(texID)->drawInRect_(destRect, color);
}

void KRTexture2DManager::drawInRect(int texID, const KRRect2D& destRect, const KRRect2D& srcRect, double alpha)
{
    _getTexture(texID)->drawInRect_(destRect, srcRect, KRColor(1, 1, 1, alpha));
}

void KRTexture2DManager::drawInRect(int texID, const KRRect2D& destRect, const KRRect2D& srcRect, const KRColor& color)
{
    _getTexture(texID)->drawInRect_(destRect, srcRect, color);
}


#pragma mark -
#pragma mark ---- アトラスの描画 ----

void KRTexture2DManager::drawAtlasAtPoint(int texID, const KRVector2DInt& atlasPos, const KRVector2D& pos, double alpha)
{
    drawAtlasAtPoint(texID, atlasPos, pos, KRColor(1, 1, 1, alpha));
}

void KRTexture2DManager::drawAtlasAtPoint(int texID, const KRVector2DInt& atlasPos, const KRVector2D& pos, const KRColor& color)
{
    KRTexture2D* theTex = _getTexture(texID);
    KRVector2D atlasSize = theTex->getAtlasSize();
    
    KRRect2D srcRect(atlasSize.x * atlasPos.x, atlasSize.y * atlasPos.y, atlasSize.x, atlasSize.y);

    theTex->drawAtPointEx_(pos, srcRect, 0.0, KRVector2DZero, KRVector2DOne, color);
}

void KRTexture2DManager::drawAtlasAtPointEx(int texID, const KRVector2DInt& atlasPos, const KRVector2D& pos, double rotate, const KRVector2D& origin, const KRVector2D& scale, double alpha)
{
    drawAtlasAtPointEx(texID, atlasPos, pos, rotate, origin, scale, KRColor(1, 1, 1, alpha));
}

void KRTexture2DManager::drawAtlasAtPointEx(int texID, const KRVector2DInt& atlasPos, const KRVector2D& pos, double rotate, const KRVector2D& origin, const KRVector2D& scale, const KRColor& color)
{
    KRTexture2D* theTex = _getTexture(texID);
    KRVector2D atlasSize = theTex->getAtlasSize();
    
    KRRect2D srcRect(atlasSize.x * atlasPos.x, atlasSize.y * atlasPos.y, atlasSize.x, atlasSize.y);
    
    theTex->drawAtPointEx_(pos, srcRect, rotate, origin, scale, color);
}

void KRTexture2DManager::drawAtlasAtPointCenter(int texID, const KRVector2DInt& atlasPos, const KRVector2D& centerPos, double alpha)
{
    drawAtlasAtPointCenter(texID, atlasPos, centerPos, KRColor(1, 1, 1, alpha));
}

void KRTexture2DManager::drawAtlasAtPointCenter(int texID, const KRVector2DInt& atlasPos, const KRVector2D& centerPos, const KRColor& color)
{
    KRTexture2D* theTex = _getTexture(texID);
    KRVector2D atlasSize = theTex->getAtlasSize();
    
    KRRect2D srcRect(atlasSize.x * atlasPos.x, atlasSize.y * atlasPos.y, atlasSize.x, atlasSize.y);
    
    theTex->drawAtPointCenterEx_(centerPos, srcRect, 0.0, KRVector2DZero, KRVector2DOne, color);
}

void KRTexture2DManager::drawAtlasAtPointCenterEx(int texID, const KRVector2DInt& atlasPos, const KRVector2D& centerPos, double rotate, const KRVector2D& origin, const KRVector2D& scale, double alpha)
{
    drawAtlasAtPointCenterEx(texID, atlasPos, centerPos, rotate, origin, scale, KRColor(1, 1, 1, alpha));
}

void KRTexture2DManager::drawAtlasAtPointCenterEx(int texID, const KRVector2DInt& atlasPos, const KRVector2D& centerPos, double rotate, const KRVector2D& origin, const KRVector2D& scale, const KRColor& color)
{
    KRTexture2D* theTex = _getTexture(texID);
    KRVector2D atlasSize = theTex->getAtlasSize();
    
    KRRect2D srcRect(atlasSize.x * atlasPos.x, atlasSize.y * atlasPos.y, atlasSize.x, atlasSize.y);
    
    theTex->drawAtPointCenterEx_(centerPos, srcRect, rotate, origin, scale, color);
}

void KRTexture2DManager::drawAtlasInRect(int texID, const KRVector2DInt& atlasPos, const KRRect2D& destRect, double alpha)
{
    drawAtlasInRect(texID, atlasPos, destRect, KRColor(1, 1, 1, alpha));
}

void KRTexture2DManager::drawAtlasInRect(int texID, const KRVector2DInt& atlasPos, const KRRect2D& destRect, const KRColor& color)
{
    KRTexture2D* theTex = _getTexture(texID);
    KRVector2D atlasSize = theTex->getAtlasSize();
    
    KRRect2D srcRect(atlasSize.x * atlasPos.x, atlasSize.y * atlasPos.y, atlasSize.x, atlasSize.y);
    
    theTex->drawInRect_(destRect, srcRect, color);
}

