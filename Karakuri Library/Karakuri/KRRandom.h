/*!
    @file   KRRandom.h
    @author numata
    @date   09/08/05
    
    Please write the description of this class.
 */

#pragma once

#include <Karakuri/Karakuri.h>


/*!
    @class  KRRandom
    @group  Game Foundation
    @abstract 乱数を生成するクラスです。
 
    <p><a href="http://www.jstatsoft.org/v08/i14/" target="_blank">XorShift</a> 法を 128bit で使って、疑似乱数を生成します。</p>
    <p>乱数のシードは、ゲームの起動時に time() 関数（標準C言語ライブラリ）と getpid() 関数（POSIX.1規格）のリターン値を元にして設定されます。</p>
    <p>このクラスのインスタンスは自分で生成せず、KRRand 定数を使ってアクセスしてください。</p>
 */
class KRRandom : public KRObject {

    unsigned x, y, z, w;

public:
	KRRandom();

private:
    unsigned xor128() KARAKURI_FRAMEWORK_INTERNAL_USE_ONLY;

public:
    /*!
        @method nextInt
        @abstract int 型の擬似乱数をリターンします。
        32ビットの int 型が取り得るすべての値が、ほぼ均等な確率で生成されます。
     */
    int     nextInt();

    /*!
        @method nextInt
        @abstract 0 から指定された値までの範囲（0 は含み、指定された値は含まない）の int 型の擬似乱数をリターンします。
        指定された範囲内で取り得るすべての値が、ほぼ均等な確率で生成されます。
     */
    int     nextInt(int upper);

    /*!
        @method nextFloat
        @abstract 0.0f ～ 1.0f の範囲で float 型の擬似乱数をリターンします。
     */
    float   nextFloat();

    /*!
        @method nextDouble
        @abstract 0.0 ～ 1.0 の範囲で double 型の擬似乱数をリターンします。
     */
    double  nextDouble();
    
public:
    virtual std::string to_s() const;

};


/*!
    @var    KRRand
    @group  Game Foundation
    @abstract 乱数生成器のインスタンスを指す変数です。
    この変数が指し示すオブジェクトは、ゲーム実行の最初から最後まで絶対に変わりません。
 */
extern KRRandom *KRRand;

