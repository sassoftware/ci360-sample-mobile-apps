import React from 'react';
import { FlatList, StyleSheet, Text, View } from 'react-native';
import { TouchableOpacity } from 'react-native-gesture-handler';

const styles = StyleSheet.create({
    container: {
        flex: 1,
        paddingTop: 22,
    },
    item: {
        padding: 10,
        fontSize: 18,
        height: 44,
    },
});

const DemoListExamples = ({ navigation }) => {
    return (
        <View style={styles.container}>
            <FlatList
                data={[
                    { key: 'Location permissions', component: "", disabled: true },
                    { key: 'Attach identity', component: "Profile", disabled: false },
                    { key: 'Detach identity', component: "Settings", disabled: false },
                    { key: 'Ad view loaded', component: "Profile", disabled: false },
                    { key: 'In-App Message', component: "Profile", disabled: true },
                    { key: 'Push notification', component: "Profile", disabled: true },
                    { key: 'Internal Search ', component: "Search", disabled: false },
                    { key: 'Add to cart', component: "Events", disabled: false },
                    { key: 'Product view', component: "Events", disabled: false },
                    { key: 'Cart operations', component: "CartEvents", disabled: false },

                ]}
                renderItem={({ item }) => <TouchableOpacity
                    onPress={() => { if (item?.disabled) { return }; navigation.navigate(item?.component) }}
                >
                    <Text disabled={item?.disabled} style={styles.item}>{item.key}</Text>
                </TouchableOpacity>}
            />
        </View>
    );
};

export default DemoListExamples;