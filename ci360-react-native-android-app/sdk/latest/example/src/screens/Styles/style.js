import { StyleSheet } from 'react-native';

const styles = StyleSheet.create({
    container: {
    flex: 1,
    justifyContent: 'flex-start',
    alignItems: 'center',
    padding: 10,
    },
    tabContainer: {
        flex: 1,
        justifyContent: 'flex-start',
        alignItems: 'center',
        padding: 10,
    },
    title: {
        fontSize: 24,
        fontWeight: 'bold',
        padding: 20,
    },
    bar: {
        height: 1,
        width: '80%',
        backgroundColor: '#333',
    },
    buttonContainer: {
        marginVertical: 8,
        width: '80%',
    },
    button: {
        flexDirection: 'row',
        alignItems: 'center',
        padding: 10,
    },
    buttonText: {
        fontSize: 24,
        marginLeft: 10,
        color: '#333',
    },
    icon: {
        color: '#333',
        marginRight: 10,
    },
    inputContainer: {
        width: '80%',
        flexDirection: 'row',
        alignItems: 'center',
        padding: 10,
    },
    input: {
        borderWidth: 1,
        borderColor: 'gray',
        backgroundColor: 'white',
        padding: 10,
        borderRadius: 5,
        width: '80%',
    },
    inputLabel: {
        fontWeight: 'bold',
        textAlign: 'left',
    },
    bigButton: {
        backgroundColor: '#0378cd',
        padding: 10,
        marginTop: 10,
        width: '50%',
        marginBottom: 20,
    },
    bigBtnText: {
        fontSize: 20,
        textAlign: 'center',
        color: '#FFF',
    },
    iconContainer: {
        borderRadius: 50,
        borderWidth: 2,
        borderColor: '#000',
        padding: 10,
        marginBottom: 20,
        marginTop: 10,
    },
    indicatorContainer: {
        position: 'absolute',
        height: 50,
        bottom: 0,
        padding: 10,
        justifyContent: 'center',
        alignItems: 'center',
    },
    inputReferenceLabel: {
        alignSelf: 'flex-start',
        left: 10,
        padding: 10,
    }
});

export default styles;