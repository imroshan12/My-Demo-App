// src/hooks/useTasks.ts
import { useCallback, useEffect, useState } from 'react';
import {
  TaskIntents,
  NativeTask,
  TaskPriority,
  TaskCategory,
  subscribeToIntents,
} from '../specs/NativeTaskIntent';

export function useTasks() {
  const [tasks, setTasks] = useState<NativeTask[]>([]);
  const [loading, setLoading] = useState(true);

  const refresh = useCallback(async () => {
    try {
      const list = await TaskIntents.getTasks(false);
      setTasks(
        list.sort((a, b) => {
          // Incomplete first, then by created date desc
          if (a.isCompleted !== b.isCompleted) {
            return a.isCompleted ? 1 : -1;
          }
          return b.createdAt - a.createdAt;
        }),
      );
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    refresh();

    // Auto-refresh whenever Siri/Shortcuts/Widget changes data
    const unsubscribe = subscribeToIntents(event => {
      console.log('[Intent Event]', event.type, event.payload);
      refresh();
    });

    return unsubscribe;
  }, [refresh]);

  const addTask = useCallback(
    async (
      title: string,
      priority: TaskPriority = 'medium',
      category: TaskCategory = 'personal',
      notes: string = '',
    ) => {
      await TaskIntents.addTask(title, priority, category, notes);
      await refresh();
    },
    [refresh],
  );

  const toggleTask = useCallback(
    async (id: string) => {
      await TaskIntents.toggleTask(id);
      await refresh();
    },
    [refresh],
  );

  const deleteTask = useCallback(
    async (id: string) => {
      await TaskIntents.deleteTask(id);
      await refresh();
    },
    [refresh],
  );

  const seedDemoData = useCallback(
    async (force: boolean = false) => {
      await TaskIntents.seedDemoData(force);
      await refresh();
    },
    [refresh],
  );

  const resetAll = useCallback(async () => {
    await TaskIntents.resetAllTasks();
    await refresh();
  }, [refresh]);

  return {
    tasks,
    loading,
    addTask,
    toggleTask,
    deleteTask,
    seedDemoData,
    resetAll,
    refresh,
  };
}
