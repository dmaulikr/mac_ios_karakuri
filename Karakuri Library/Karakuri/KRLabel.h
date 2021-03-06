/*!
    @file   KRLabel.h
    @author numata
    @date   09/08/29
    
    Please write the description of this class.
 */

#pragma once

#include <Karakuri/KRControl.h>
#include <Karakuri/KRTexture2D.h>
#include <Karakuri/KRFont.h>


/*!
    @enum   KRTextAlignment
    @group  Game Controls
    @constant KRTextAlignmentLeft   左寄せ
    @constant KRTextAlignmentCenter 中央寄せ
    @constant KRTextAlignmentRight  右寄せ
    文字列の横方向の配置方法を表す列挙型です。
 */
typedef enum {
    KRTextAlignmentLeft,
    KRTextAlignmentCenter,
    KRTextAlignmentRight,
} KRTextAlignment;


/*!
    @class KRLabel
    @group Game Controls
    テキストラベルを表すためのクラスです。
 */
class KRLabel : public KRControl {

protected:
    std::string     mText;
    _KRTexture2D*   mTextTexture;
    _KRFont*        mFont;
    KRColor         mTextColor;
    bool            mHasChangedText;
    KRTextAlignment mTextAlignment;
    
    KRColor         mTextShadowColor;
    KRVector2D      mTextShadowOffset;
    bool            mHasTextShadow;
    
public:
    /*!
        @task コンストラクタ
     */
    
    /*!
        @method KRLabel
        位置と大きさを指定して、このラベルを生成します。
     */
	KRLabel(const KRRect2D& frame);
	virtual ~KRLabel();
    
public:
    virtual bool    update(KRInput* input); KARAKURI_FRAMEWORK_INTERNAL_USE_ONLY
    virtual void    draw(KRGraphics* g);    KARAKURI_FRAMEWORK_INTERNAL_USE_ONLY
    
public:
    /*!
        @task 状態の設定
     */
    
    /*!
        @method getText
        このラベルに設定されたテキストを取得します。
     */
    std::string     getText() const;

    /*!
        @method setText
        このラベルのテキストを設定します。
     */
    void            setText(const std::string& text);
    
    /*!
        @task 見た目の設定
     */

    /*!
        @method getTextAlignment
        このラベルに設定された横方向のテキスト配置方法を取得します。
     */
    KRTextAlignment getTextAlignment() const;
    
    /*!
        @method setFont
        @abstract テキストを描画するためのフォントを設定します。
     */
    void    setFont(const std::string& fontName, double size);
    
    /*!
        @method setHasTextShadow
        @abstract テキストに影を付けるかどうかを設定します。
     */
    void    setHasTextShadow(bool flag);
    
    void    setTextShadowColor(const KRColor& color);
    void    setTextShadowOffset(const KRVector2D& offset);
    
    /*!
        @method setTextAlignment
        横方向のテキスト配置方法を設定します。
     */
    void    setTextAlignment(KRTextAlignment alignment);
    
    /*!
        @method setTextColor
        このラベルのテキスト描画色を設定します。
     */
    void    setTextColor(const KRColor& color);
    
    virtual bool    _isUpdatableControl() const; KARAKURI_FRAMEWORK_INTERNAL_USE_ONLY

};

