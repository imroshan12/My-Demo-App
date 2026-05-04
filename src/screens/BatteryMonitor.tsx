import { useEffect, useState } from 'react';
import { NativeEventEmitter, NativeModules, Text, View } from 'react-native';

const { BatteryModule } = NativeModules;

const batteryEmitter = new NativeEventEmitter(BatteryModule);

export const BatteryMonitor = () => {
  const [batteryInfo, setBatteryInfo] = useState<any>(null);
  const [lowPowerMode, setLowPowerMode] = useState<any>(null);

  useEffect(() => {
    BatteryModule.getBatteryInfo()
      .then((info: any) => setBatteryInfo(info))
      .catch((error: any) =>
        console.error('Error fetching battery info:', error),
      );

    const batterySub = batteryEmitter.addListener(
      'onBatteryChange',
      (info: any) => {
        setBatteryInfo((prev: any) => ({ ...prev, ...info }));
      },
    );

    const powerModeSub = batteryEmitter.addListener(
      'onLowPowerModeChange',
      (info: any) => {
        setLowPowerMode(info.isLowPowerMode);
      },
    );

    return () => {
      batterySub.remove();
      powerModeSub.remove();
    };
  }, []);

  if (!batteryInfo) return <Text>Loading battery info...</Text>;

  return (
    <View>
      <Text>Battery: {batteryInfo?.percentage}%</Text>
      <Text>
        {batteryInfo?.state === BatteryModule.STATE_CHARGING
          ? '⚡ Charging'
          : '🔋 On Battery'}
      </Text>
      <Text>Low Power: {lowPowerMode ? 'ON' : 'OFF'}</Text>
    </View>
  );
};
