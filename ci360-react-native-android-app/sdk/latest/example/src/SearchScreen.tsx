import React, { useState } from 'react';
import { ScrollView, StyleSheet, Text, TextInput, View, TouchableOpacity } from 'react-native';
import { addAppEvent } from 'mobile-sdk-react-native';
import SpotsScreen from './SpotsScreen';

const SearchScreen = () => {
  const [search, setSearch] = useState('');
  const [searchError, setSearchError] = useState('');
  const [searchClicked, setSearchClicked] = useState(false);

  const handleSubmit = async () => {
    if (!search.trim()) {
      setSearchError('search field cannot be empty.');

      if (search.length === 0) {
        return;
      }
    } else {
      setSearchError('');
      setSearch(search);
      setSearchClicked(true)
      const map1 = new Map();
      map1.set("searchName", search)
      map1.set("searchTerm", search)
      map1.set("resultsDisplayed", 3)
      map1.set("resultsDisplayFlag", "yes")
      map1.set("searchFieldId", "searchQuery")
      map1.set("searchFieldName", "searchQuery")

      addAppEvent("searchOnMobile", map1);
    }
  };

  return (
    <ScrollView>
      <View style={styles.container}>
        <Text style={styles.title}>Search</Text>
        {/* Add any other components or functionality you need */}
        <Text >Enter search query</Text>
        <TextInput
          id='searchQuery'
          name="searchQuery"
          placeholder="Search"
          autoCapitalize="none"
          autoCorrect={false}
          style={styles.input} onChangeText={(e) => {
            setSearch(e);
            setSearchError('');
          }} ></TextInput>
        <TouchableOpacity
          style={styles.bigButton}
          onPress={handleSubmit}
        >
          <Text style={styles.bigBtnText}>Search</Text>
        </TouchableOpacity>
        <Text>{searchError || ""}</Text>
        <SpotsScreen spotId={searchClicked ? "GP_spot3" : ""}></SpotsScreen>
      </View>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 16,
  },
  input: {
    borderWidth: 1,
    borderColor: 'gray',
    backgroundColor: 'white',
    padding: 10,
    borderRadius: 5,
    width: '70%'
  },
  bigBtnText: {
    fontSize: 20,
    textAlign: 'center',
    color: '#FFF'
  },
  bigButton: {
    backgroundColor: '#0378cd',
    padding: 10,
    marginTop: 10,
    width: '45%',
    marginBottom: 20,
    marginRight: 10
  },
});

export default SearchScreen;