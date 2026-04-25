import {
  ActivityIndicator,
  FlatList,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import {
  DrawerActions,
  getFocusedRouteNameFromRoute,
  NavigationContainer,
} from '@react-navigation/native';
import {
  createDrawerNavigator,
  DrawerContentComponentProps,
} from '@react-navigation/drawer';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import HomeScreen from './screens/HomeScreen';
import ProfileScreen from './screens/ProfileScreen';
import SettingsScreen from './screens/SettingsScreen';
import { GestureHandlerRootView } from 'react-native-gesture-handler';
const Drawer = createDrawerNavigator();
const Stack = createNativeStackNavigator();

const drawerItems = [
  { key: 'Home', label: 'Home', screen: 'Home' },
  { key: 'Profile', label: 'Profile', screen: 'ProfileScreen' },
  { key: 'Settings', label: 'Settings', screen: 'SettingsScreen' },
];

const CustomDrawerContent = (props: DrawerContentComponentProps) => {
  const { state, navigation } = props;

  // Safe route extraction using React Navigation's helper
  const focusedDrawerRoute = state.routes[state.index];
  const currentRoute =
    getFocusedRouteNameFromRoute(focusedDrawerRoute) ?? 'Home';

  const handlePress = (item: (typeof drawerItems)[0]) => {
    navigation.navigate('DrawerNavigator', { screen: item.screen });
    navigation.dispatch(DrawerActions.closeDrawer());
  };

  const renderItem = ({ item }: { item: (typeof drawerItems)[0] }) => (
    <TouchableOpacity
      style={[
        styles.drawerItem,
        currentRoute === item.screen && styles.drawerItemSelected,
      ]}
      onPress={() => handlePress(item)}
      activeOpacity={0.7}
    >
      <Text
        style={[
          styles.drawerItemText,
          currentRoute === item.screen && styles.drawerItemTextSelected,
        ]}
      >
        {item.label}
      </Text>
    </TouchableOpacity>
  );

  return (
    <View style={styles.drawerContainer}>
      <Text style={styles.drawerTitle}>Menu</Text>
      <FlatList
        data={drawerItems}
        renderItem={renderItem}
        keyExtractor={item => item.key}
        contentContainerStyle={styles.drawerList}
      />
    </View>
  );
};

const HomeStackNavigator = () => (
  <Stack.Navigator
    initialRouteName="Home"
    screenOptions={() => ({
      headerShown: true,
      animation: 'slide_from_right',
      headerStyle: {
        backgroundColor: '#4f8cff',
      },
      headerTintColor: '#fff',
      headerTitleStyle: {
        fontWeight: 'bold',
      },
    })}
  >
    <Stack.Screen
      name="Home"
      component={HomeScreen}
      options={{ title: 'Home' }}
    />
    <Stack.Screen
      name="ProfileScreen"
      component={ProfileScreen}
      options={{ title: 'Profile' }}
    />
    <Stack.Screen
      name="SettingsScreen"
      component={SettingsScreen}
      options={{ title: 'Settings' }}
    />
  </Stack.Navigator>
);

const NavigationStack = () => (
  <Drawer.Navigator
    screenOptions={{
      headerShown: false,
      drawerType: 'slide',
    }}
    drawerContent={CustomDrawerContent}
    initialRouteName="DrawerNavigator"
  >
    <Drawer.Screen name="DrawerNavigator" component={HomeStackNavigator} />
  </Drawer.Navigator>
);

function App() {
  return (
    <GestureHandlerRootView>
      <NavigationContainer>
        <NavigationStack />
      </NavigationContainer>
    </GestureHandlerRootView>
  );
}

export default App;

const styles = StyleSheet.create({
  centered: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  drawerContainer: {
    flex: 1,
    paddingTop: 60,
    backgroundColor: '#fff',
  },
  drawerTitle: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 30,
    alignSelf: 'center',
    color: '#333',
  },
  drawerList: {
    paddingHorizontal: 20,
  },
  drawerItem: {
    paddingVertical: 16,
    paddingHorizontal: 20,
    borderRadius: 10,
    marginBottom: 12,
    backgroundColor: '#f5f5f5',
    flexDirection: 'row',
    alignItems: 'center',
  },
  drawerItemSelected: {
    backgroundColor: '#4f8cff',
  },
  drawerItemText: {
    fontSize: 18,
    color: '#333',
    fontWeight: '500',
  },
  drawerItemTextSelected: {
    color: '#fff',
    fontWeight: 'bold',
  },
});
