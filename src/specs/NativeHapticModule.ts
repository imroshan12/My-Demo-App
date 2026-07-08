import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

export interface Spec extends TurboModule {
  isSupported(): boolean;
  impact(style: string): void;
  notification(type: string): void;
  selection(): void;
}

export default TurboModuleRegistry.getEnforcing<Spec>('HapticModule');
