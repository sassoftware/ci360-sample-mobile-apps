//
//#*************************************************************************************************************#
//# Application Name: SAS CI360 React Native Demo Application                                                        #
//# File Name: CustomButton.tsx                                                                                   #
//# File Description: Reusable button component for consistent styling and behavior across example screens. #
//# Author: SAS Global CX-CI                                                                                    #
//# Date: 31-October-2023       
//# Copyright  2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.                                   #
//# SPDX-License-Identifier: Apache-2.0                                                                         #
//#*************************************************************************************************************#
//
import { FC, ReactElement } from 'react';

import { StyleSheet, Text, Pressable } from 'react-native';

type CustomButtonProps = {
  title: string,
  onPress: () => void,
  width: {width: number}
};

const CustomButton: FC<CustomButtonProps> = ({title, onPress, width}): ReactElement => {
  if (width) {
    styles.buttonWidth.width = width.width;
  }
    return (
        <Pressable
          style={({pressed}) => pressed ? [styles.container, styles.pressed, styles.buttonWidth] : [styles.container, styles.buttonWidth]}
          onPress={onPress}
          android_ripple={{color: '#00b0ff'}}>
            <Text style={styles.title}>{title}</Text>
        </Pressable>
    )
};

export default CustomButton;

const styles = StyleSheet.create({
    container: {
        alignItems: 'center',
        justifyContent: 'center',
        marginVertical: 30,
        height: 40,
        backgroundColor: '#14AAF5',//'#00b0ff',
        borderRadius: 5,
    },
    buttonWidth: {
      width: 150,
    },
    title: {
        color: 'white',
    },
    pressed: {
      opacity: 0.7
    }
})
