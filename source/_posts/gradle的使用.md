---
title: gradle的使用
date: 2016-06-20 23:31:50
tags: Android
---

### gradle 多分支使用不同的签名文件打包

- 参考链接[https://chobitly.github.io/2016/02/05/Android-Gradle-Build/index.html]

```
    android {
        signingConfigs {
            debug {} //debug debug版本
            release {} //正式签名版本
            third {} //另一个签名配置
        }
        buildTypes {
            debug {
                applicationIdSuffix ".debug"
            }
            release {
                signingConfig singingConfigs.release
            }

            third {
                signingConfig singingConfigs.third
            }
        }
        //产品不同分支
        productFlavors {
            alpha_fittime {
                applicationId = ""
                manifestPlaceholders = []
            }
            beta_fittime {
                applicationId = ""
                manifestPlaceholders = []
            }
            product_fittime {
                applicationId = ""
                manifestPlaceholders = []
            }
        }
    }

//读取sign key配置  relese版本
File releaseFile = file('release.properties');
if (releaseFile.exists()) {
    def Properties releasePt = new Properties()
    releasePt.load(new FileInputStream(releaseFile))
    if (releasePt.containsKey('STORE_FILE') && releasePt.containsKey('STORE_PASSWORD') &&
            releasePt.containsKey('KEY_ALIAS') && releasePt.containsKey('KEY_PASSWORD')) {
        android.signingConfigs.release.storeFile = file(releasePt['STORE_FILE'])
        android.signingConfigs.release.storePassword = releasePt['STORE_PASSWORD']
        android.signingConfigs.release.keyAlias = releasePt['KEY_ALIAS']
        android.signingConfigs.release.keyPassword = releasePt['KEY_PASSWORD']
    } else {
        android.buildTypes.release.signingConfig = null
    }
} else {
    android.buildTypes.release.signingConfig = null
}

//读取sign key配置  third 版本
File thirdFile = file('third.properties');
if (thirdFile.exists()) {
    def Properties thirdPt = new Properties()
    thirdPt.load(new FileInputStream(thirdFile))
    if (thirdPt.containsKey('STORE_FILE') && thirdPt.containsKey('STORE_PASSWORD') &&
            thirdPt.containsKey('KEY_ALIAS') && thirdPt.containsKey('KEY_PASSWORD')) {
        android.signingConfigs.third.storeFile = file(thirdPt['STORE_FILE'])
        android.signingConfigs.third.storePassword = thirdPt['STORE_PASSWORD']
        android.signingConfigs.third.keyAlias = thirdPt['KEY_ALIAS']
        android.signingConfigs.third.keyPassword = thirdPt['KEY_PASSWORD']
    } else {
        android.buildTypes.third.signingConfig = null
    }
} else {
    android.buildTypes.third.signingConfig = null
}
```

---

#### 打包命令：

- gradle aR   打包的release 使用 release.properties 文件配置的key信息，third 使用third.properties 文件配置的key信息


### gradle 每一个分支使用不同签名文件打包

- 参考链接[http://stackoverflow.com/questions/17040494/signing-product-flavors-with-gradle]

```
android {
    signingConfigs {
        debug {} //debug debug版本
        release {} //正式签名版本
        third {} //另一个签名配置
    }
    buildTypes {
        debug {
            applicationIdSuffix ".debug"
        }
        release {
            signingConfig singingConfigs.release
        }

        third {
            signingConfig singingConfigs.third
        }
    }
    //产品不同分支
    productFlavors {
        //首先定义局部的打包需要的配置
        def defaultSigning = signingConfigs.release
        def thirdSigning = signingConfigs.third
        alpha_fittime {
            applicationId = ""
            manifestPlaceholders = []
            signingConfig defaultSigning //使用默认签名
        }
        beta_fittime {
            applicationId = ""
            manifestPlaceholders = []
            signingConfig defaultSigning //使用默认签名
        }
        product_fittime {
            applicationId = ""
            manifestPlaceholders = []
            signingConfig defaultSigning //使用默认签名
        }
        third_fittime {
            applicationId = ""
            manifestPlaceholders = []
            signingConfig thirdSigning //使用third签名
        }

    }
}

//读取sign key配置  relese版本
File releaseFile = file('release.properties');
if (releaseFile.exists()) {
    def Properties releasePt = new Properties()
    releasePt.load(new FileInputStream(releaseFile))
    if (releasePt.containsKey('STORE_FILE') && releasePt.containsKey('STORE_PASSWORD') &&
            releasePt.containsKey('KEY_ALIAS') && releasePt.containsKey('KEY_PASSWORD')) {
        android.signingConfigs.release.storeFile = file(releasePt['STORE_FILE'])
        android.signingConfigs.release.storePassword = releasePt['STORE_PASSWORD']
        android.signingConfigs.release.keyAlias = releasePt['KEY_ALIAS']
        android.signingConfigs.release.keyPassword = releasePt['KEY_PASSWORD']
    } else {
        android.buildTypes.release.signingConfig = null
    }
} else {
    android.buildTypes.release.signingConfig = null
}

//读取sign key配置  third 版本
File thirdFile = file('third.properties');
if (thirdFile.exists()) {
    def Properties thirdPt = new Properties()
    thirdPt.load(new FileInputStream(thirdFile))
    if (thirdPt.containsKey('STORE_FILE') && thirdPt.containsKey('STORE_PASSWORD') &&
            thirdPt.containsKey('KEY_ALIAS') && thirdPt.containsKey('KEY_PASSWORD')) {
        android.signingConfigs.third.storeFile = file(thirdPt['STORE_FILE'])
        android.signingConfigs.third.storePassword = thirdPt['STORE_PASSWORD']
        android.signingConfigs.third.keyAlias = thirdPt['KEY_ALIAS']
        android.signingConfigs.third.keyPassword = thirdPt['KEY_PASSWORD']
    } else {
        android.buildTypes.third.signingConfig = null
    }
} else {
    android.buildTypes.third.signingConfig = null
}
```

- 这样就可以使得 productFlavors 中的third_fittime  单独只用自己的第三方签名