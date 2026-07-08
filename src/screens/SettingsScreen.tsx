import React, { useState } from 'react';
import { View, Text, StyleSheet, Switch, TouchableOpacity } from 'react-native';
import NativeHapticModule from '../specs/NativeHapticModule';

const SettingsScreen = ({}: any) => {
  const [darkMode, setDarkMode] = useState(false);
  const [notifications, setNotifications] = useState(true);

  const hapticsAvailable = NativeHapticModule.isSupported();

  const handleToggle = (setter: Function, value: boolean) => {
    setter(!value);
    if (hapticsAvailable) {
      NativeHapticModule.selection();
    }
  };

  const handleSave = () => {
    if (hapticsAvailable) {
      NativeHapticModule.notification('success');
    }
  };

  const handleDelete = () => {
    if (hapticsAvailable) {
      NativeHapticModule.notification('error');
    }
  };

  return (
    <View style={styles.container}>
      <View>
        <Text>Dark Mode</Text>
        <Switch
          value={darkMode}
          onValueChange={() => handleToggle(setDarkMode, darkMode)}
        />
      </View>
      <View>
        <Text>Notifications</Text>
        <Switch
          value={notifications}
          onValueChange={() => handleToggle(setNotifications, notifications)}
        />
      </View>
      <TouchableOpacity onPress={handleSave}>
        <Text>Save Settings</Text>
      </TouchableOpacity>
      <TouchableOpacity onPress={handleDelete}>
        <Text>Delete account</Text>
      </TouchableOpacity>
      {!hapticsAvailable && (
        <Text style={{ color: 'gray', marginTop: 20 }}>
          Haptic feedback not available on this device
        </Text>
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 10,
  },
  description: {
    fontSize: 16,
    textAlign: 'center',
    marginBottom: 20,
  },
});

export default SettingsScreen;
