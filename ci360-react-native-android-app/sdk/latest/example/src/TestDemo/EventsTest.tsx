import { addAppEvent } from 'mobile-sdk-react-native';
import * as React from 'react';
import { Button, ScrollView, StyleSheet, TextInput, View } from 'react-native';
import SpotsScreen from '../SpotsScreen';

export default function EventsTestScreen() {
    const [smallMsg, setSmallMsg] = React.useState('productViewEvent');

    const [viewProductWindowClicked, setviewProductWindowClicked] = React.useState(false);
    const [showProductClicked, setShowProductClicked] = React.useState(false);

    const [addToCartClicked, setAddToCartClicked] = React.useState(false);
    const [showAddToCartClicked, setshowAddToCartClickedClicked] = React.useState(false);

    return (
        <ScrollView>
            <View style={styles.container}>
                <View>
                    <Button title='View product UseCase' width={{ width: 200 }} onPress={() => {
                        setShowProductClicked(!showProductClicked);
                        setshowAddToCartClickedClicked(false);
                    }} />
                    <View style={styles.spacer} />
                    <Button title='Add to cart UseCase' width={{ width: 200 }} onPress={() => {
                        setshowAddToCartClickedClicked(!showAddToCartClicked);
                        setShowProductClicked(false);
                    }} />
                </View>
                {showProductClicked && (
                    <>
                        <View style={styles.spacer} />
                        <View style={styles.spot}>
                            <TextInput style={styles.textInput} onChangeText={setSmallMsg} value={smallMsg} />
                            <Button title='Show product' width={{ width: 200 }} onPress={() => {
                                setviewProductWindowClicked(true);
                                const map21 = new Map();
                                map21.set("productName", "productName")
                                map21.set("productId", "productId")
                                map21.set("productSku", "productSku")
                                map21.set("productGroup", "productGroup")
                                map21.set("availabilityMessage", "availabilityMessage")
                                map21.set("shippingMessage", "shippingMessage")
                                map21.set("savingsMessage", "savingsMessage")
                                map21.set("productUnitPrice", 1234)
                                // map2.set("TriggerPushNotification", 1)
                                addAppEvent("productViewEvent", map21);
                            }} />
                        </View>
                        <SpotsScreen spotId={viewProductWindowClicked ? "GP_spot_6" : ""}></SpotsScreen>
                    </>)
                }
                {showAddToCartClicked && (
                    <>
                        <View style={styles.spacer} />
                        <View style={styles.spot}>
                            <TextInput style={styles.textInput} value={"AddToCart_TestMobile"} />
                            <Button title='Show Add To cart Use Case' width={{ width: 200 }} onPress={() => {
                                setAddToCartClicked(true);
                                const map211 = new Map();
                                map211.set("productName", "productName")
                                map211.set("productId", "productId")
                                map211.set("productSku", "productSku")
                                map211.set("productGroup", "productGroup")
                                map211.set("availabilityMessage", "availabilityMessage")
                                map211.set("shippingMessage", "shippingMessage")
                                map211.set("savingsMessage", "savingsMessage")
                                map211.set("productUnitPrice", 1234)
                                map211.set("productQuantity", 12)

                                // map2.set("TriggerPushNotification", 1)
                                addAppEvent("AddToCart_TestMobile", map211);
                            }} />
                        </View>
                        <SpotsScreen spotId={addToCartClicked ? "Spot_AddToCart_TestMobile" : ""}></SpotsScreen>
                    </>)
                }
            </View>
        </ScrollView>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        alignItems: 'center',
        paddingTop: 20
    },
    spot: {
        flex: 1,
        alignItems: 'center',
        justifyContent: 'space-evenly',
        width: 300,
        paddingVertical: 20,

        borderWidth: 1,
        borderColor: 'light-gray',
        borderRadius: 10
    },
    textInput: {
        height: 40,
        width: 200,
        margin: 5,
        borderWidth: 1,
        padding: 5,
    },
    spacer: {
        height: 20
    }
});
