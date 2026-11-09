plugins {
    id("com.android.asset-pack")
}

assetPack {
    packName = "gemma_pack1"
    dynamicDelivery {
        deliveryType = "install-time"
    }
}
