package com.mobilesdkreactnative;

import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.facebook.react.bridge.ReadableType;
import com.facebook.react.bridge.ReadableArray;
import java.util.HashMap;
import java.util.Map;
import java.util.ArrayList;
import java.util.List;

public class MapConverter {

  public static HashMap<String, String> convertReadableMapToHashMap(ReadableMap readableMap) {
    HashMap<String, String> hashMap = new HashMap<>();
    ReadableMapKeySetIterator iterator = readableMap.keySetIterator();

    while (iterator.hasNextKey()) {
      String key = iterator.nextKey();
      ReadableType type = readableMap.getType(key);

      switch (type) {
        case String:
          hashMap.put(key, readableMap.getString(key));
          break;
//        case Number:
//          hashMap.put(key, readableMap.getDouble(key));
//          break;
//        case Boolean:
//          hashMap.put(key, readableMap.getBoolean(key));
//          break;
//        case Map:
//          hashMap.put(key, convertReadableMapToHashMap(readableMap.getMap(key)));
//          break;
//        case Array:
//          hashMap.put(key, convertReadableArrayToList(readableMap.getArray(key)));
//          break;
//        case Null:
//          hashMap.put(key, null);
//          break;
        default:
          throw new IllegalArgumentException("Could not convert object with key: " + key + ".");
      }
    }

    return hashMap;
  }

  private static List<Object> convertReadableArrayToList(ReadableArray readableArray) {
    List<Object> list = new ArrayList<>();

    for (int i = 0; i < readableArray.size(); i++) {
      ReadableType type = readableArray.getType(i);

      switch (type) {
        case String:
          list.add(readableArray.getString(i));
          break;
        case Number:
          list.add(readableArray.getDouble(i));
          break;
        case Boolean:
          list.add(readableArray.getBoolean(i));
          break;
        case Map:
          list.add(convertReadableMapToHashMap(readableArray.getMap(i)));
          break;
        case Array:
          list.add(convertReadableArrayToList(readableArray.getArray(i)));
          break;
        case Null:
          list.add(null);
          break;
        default:
          throw new IllegalArgumentException("Could not convert array item at index: " + i + ".");
      }
    }

    return list;
  }
}
