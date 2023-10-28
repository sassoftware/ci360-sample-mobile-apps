

import * as React from 'react';
import { Button, ScrollView, StyleSheet, Text, View } from 'react-native';

export default function CartEventsTestScreen() {
    const [counter, setCounter] = React.useState(0);

    const [plusClicked, setPlusClicked] = React.useState(false);
    const [minusClicked, setminusClicked] = React.useState(false);

    const handlePlusClicked = () => {
        setCounter(counter + 1);
        console.log("counter::::", counter)
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

    }

    const handleMinusClicked = () => {
        setCounter(counter - 1);
        console.log("counter::::", counter)
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
    }

    return (
        <ScrollView>
            <View style={styles.container}>
                <View>
                    <Button title='+' width={{ width: 200 }} onPress={handlePlusClicked} />
                    <View style={styles.spacer} />
                    <Text>{counter}</Text>
                    <View style={styles.spacer} />
                    <Button title='-' width={{ width: 200 }} onPress={handleMinusClicked} />
                </View>
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
