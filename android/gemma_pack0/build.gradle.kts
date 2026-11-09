plugins {
    id("com.android.asset-pack")
}

assetPack {
    packName = "gemma_pack0"
    dynamicDelivery {
        deliveryType = "install-time"
    }
}
