// specs/NativeTaskIntents.ts
import {
  NativeModules,
  NativeEventEmitter,
  EmitterSubscription,
} from 'react-native';

export type TaskPriority = 'low' | 'medium' | 'high' | 'urgent';
export type TaskCategory =
  | 'work'
  | 'personal'
  | 'shopping'
  | 'health'
  | 'learning';

export interface NativeTask {
  id: string;
  title: string;
  notes: string;
  isCompleted: boolean;
  priority: TaskPriority;
  category: TaskCategory;
  dueDate?: number;
  createdAt: number;
}

export type IntentEventType =
  | 'taskAdded'
  | 'taskToggled'
  | 'taskDeleted'
  | 'demoDataSeeded';

export interface IntentEvent {
  type: IntentEventType;
  payload: Record<string, unknown>;
}

interface TaskIntentsModuleType {
  addTask(
    title: string,
    priority: TaskPriority,
    category: TaskCategory,
    notes: string,
  ): Promise<NativeTask>;

  getTasks(onlyIncomplete: boolean): Promise<NativeTask[]>;

  toggleTask(id: string): Promise<NativeTask>;

  deleteTask(id: string): Promise<boolean>;

  seedDemoData(force: boolean): Promise<{ count: number }>;

  resetAllTasks(): Promise<boolean>;
}

const { TaskIntentsModule } = NativeModules;

if (!TaskIntentsModule) {
  throw new Error(
    'TaskIntentsModule is not linked. Ensure native module is registered and the app was rebuilt.',
  );
}

export const TaskIntents = TaskIntentsModule as TaskIntentsModuleType;

const emitter = new NativeEventEmitter(TaskIntentsModule);

export function subscribeToIntents(
  callback: (event: IntentEvent) => void,
): () => void {
  const subscription: EmitterSubscription = emitter.addListener(
    'onIntentTriggered',
    callback,
  );
  return () => subscription.remove();
}
