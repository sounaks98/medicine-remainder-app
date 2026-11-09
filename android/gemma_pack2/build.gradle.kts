plugins {
    id("com.android.asset-pack")
}

assetPack {
    packName = "gemma_pack2"
    dynamicDelivery {
        deliveryType = "install-time"
    }
}
