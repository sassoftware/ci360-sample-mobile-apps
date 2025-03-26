import { FC } from 'react';
import { View, Button, Text, StyleSheet } from 'react-native';
import JsonCreative from '../models/JsonCreative';

interface CreativeProps {
  spotId: string;
  creative: JsonCreative;
  registerSpotClicked: (spotId: string) => void;
}

const JsonCreativeView: FC<CreativeProps> = ({
  spotId,
  creative,
  registerSpotClicked,
}) => {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>{creative.title}</Text>
      <Text style={styles.subTitle}>{creative.subTitle}</Text>
      {creative.bullets.map((b, index) => (
        <View key={index} style={styles.bulletedItem}>
          <Text style={styles.bulletIcon}>•</Text>
          <Text style={styles.bulletedItem}>{b}</Text>
        </View>
      ))}
      <Button
        onPress={() => registerSpotClicked(spotId)}
        title={creative.buttonText}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    margin: 16,
    padding: 16,
    borderColor: 'light-gray',
    borderWidth: 2,
    borderRadius: 8,
    marginBottom: 16,
  },
  title: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 4,
  },
  subTitle: {
    fontSize: 14,
    fontStyle: 'italic',
    marginBottom: 4,
  },
  bulletedItem: {
    flexDirection: 'row',
    alignItems: 'flex-start',
    fontSize: 12,
  },
  bulletIcon: {
    fontSize: 16,
    marginRight: 4,
  },
});

export default JsonCreativeView;
