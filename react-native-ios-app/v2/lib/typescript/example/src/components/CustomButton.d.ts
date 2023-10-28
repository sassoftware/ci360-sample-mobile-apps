import { FC } from 'react';
type CustomButtonProps = {
    title: string;
    onPress: () => void;
    width: {
        width: number;
    };
};
declare const CustomButton: FC<CustomButtonProps>;
export default CustomButton;
