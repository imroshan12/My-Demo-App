// src/screens/TaskListScreen.tsx
import React, { useState } from 'react';
import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  FlatList,
  StyleSheet,
  Alert,
} from 'react-native';
import { useTasks } from '../hooks/useTasks';
import { TaskPriority, TaskCategory } from '../specs/NativeTaskIntent';

const PRIORITY_COLORS: Record<TaskPriority, string> = {
  urgent: '#FF3B30',
  high: '#FF9500',
  medium: '#007AFF',
  low: '#8E8E93',
};

const CATEGORY_ICONS: Record<TaskCategory, string> = {
  work: '💼',
  personal: '👤',
  shopping: '🛒',
  health: '❤️',
  learning: '📚',
};

export function TaskListScreen() {
  const {
    tasks,
    loading,
    addTask,
    toggleTask,
    deleteTask,
    seedDemoData,
    resetAll,
  } = useTasks();
  const [newTitle, setNewTitle] = useState('');

  const handleAdd = async () => {
    if (!newTitle.trim()) return;
    await addTask(newTitle.trim(), 'medium', 'personal');
    setNewTitle('');
  };

  const handleDelete = (id: string, title: string) => {
    Alert.alert('Delete Task', `Delete "${title}"?`, [
      { text: 'Cancel', style: 'cancel' },
      { text: 'Delete', style: 'destructive', onPress: () => deleteTask(id) },
    ]);
  };

  const handleReset = () => {
    Alert.alert('Reset', 'Delete all tasks?', [
      { text: 'Cancel', style: 'cancel' },
      { text: 'Reset', style: 'destructive', onPress: resetAll },
    ]);
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>TaskMaster</Text>
      <Text style={styles.subtitle}>
        {tasks.filter(t => !t.isCompleted).length} pending
      </Text>

      <View style={styles.inputRow}>
        <TextInput
          style={styles.input}
          placeholder="New task..."
          value={newTitle}
          onChangeText={setNewTitle}
          onSubmitEditing={handleAdd}
        />
        <TouchableOpacity style={styles.addButton} onPress={handleAdd}>
          <Text style={styles.addButtonText}>+</Text>
        </TouchableOpacity>
      </View>

      <View style={styles.toolbar}>
        <TouchableOpacity
          style={styles.toolBtn}
          onPress={() => seedDemoData(false)}
        >
          <Text style={styles.toolBtnText}>✨ Load Demo</Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={styles.toolBtn}
          onPress={() => seedDemoData(true)}
        >
          <Text style={styles.toolBtnText}>🔄 Reload Demo</Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={[styles.toolBtn, styles.dangerBtn]}
          onPress={handleReset}
        >
          <Text style={[styles.toolBtnText, { color: '#FF3B30' }]}>
            🗑️ Reset
          </Text>
        </TouchableOpacity>
      </View>

      {loading ? (
        <Text style={styles.loading}>Loading...</Text>
      ) : (
        <FlatList
          data={tasks}
          keyExtractor={item => item.id}
          ListEmptyComponent={
            <Text style={styles.empty}>
              No tasks yet. Tap "Load Demo" or ask Siri to add one!
            </Text>
          }
          renderItem={({ item }) => (
            <TouchableOpacity
              style={styles.taskRow}
              onPress={() => toggleTask(item.id)}
              onLongPress={() => handleDelete(item.id, item.title)}
            >
              <View
                style={[
                  styles.checkbox,
                  item.isCompleted && styles.checkboxChecked,
                ]}
              >
                {item.isCompleted && <Text style={styles.check}>✓</Text>}
              </View>
              <View style={styles.taskBody}>
                <Text
                  style={[
                    styles.taskTitle,
                    item.isCompleted && styles.taskTitleDone,
                  ]}
                >
                  {CATEGORY_ICONS[item.category]} {item.title}
                </Text>
                {item.notes ? (
                  <Text style={styles.taskNotes} numberOfLines={1}>
                    {item.notes}
                  </Text>
                ) : null}
              </View>
              <View
                style={[
                  styles.priorityBadge,
                  { backgroundColor: PRIORITY_COLORS[item.priority] },
                ]}
              />
            </TouchableOpacity>
          )}
        />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, padding: 20, paddingTop: 60, backgroundColor: '#fff' },
  title: { fontSize: 32, fontWeight: '700' },
  subtitle: { fontSize: 14, color: '#666', marginBottom: 20 },
  inputRow: { flexDirection: 'row', marginBottom: 12 },
  input: {
    flex: 1,
    height: 44,
    borderWidth: 1,
    borderColor: '#ddd',
    borderRadius: 8,
    paddingHorizontal: 12,
    fontSize: 16,
  },
  addButton: {
    width: 44,
    height: 44,
    backgroundColor: '#007AFF',
    borderRadius: 8,
    marginLeft: 8,
    alignItems: 'center',
    justifyContent: 'center',
  },
  addButtonText: { color: '#fff', fontSize: 24, fontWeight: '600' },
  toolbar: { flexDirection: 'row', marginBottom: 16, gap: 8 },
  toolBtn: {
    paddingHorizontal: 12,
    paddingVertical: 8,
    backgroundColor: '#F2F2F7',
    borderRadius: 6,
  },
  dangerBtn: { backgroundColor: '#FFE5E5' },
  toolBtnText: { fontSize: 13, fontWeight: '500' },
  loading: { textAlign: 'center', marginTop: 40, color: '#999' },
  empty: { textAlign: 'center', marginTop: 40, color: '#999', fontSize: 14 },
  taskRow: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 12,
    paddingHorizontal: 4,
    borderBottomWidth: StyleSheet.hairlineWidth,
    borderBottomColor: '#eee',
  },
  checkbox: {
    width: 24,
    height: 24,
    borderRadius: 12,
    borderWidth: 2,
    borderColor: '#999',
    marginRight: 12,
    alignItems: 'center',
    justifyContent: 'center',
  },
  checkboxChecked: { backgroundColor: '#34C759', borderColor: '#34C759' },
  check: { color: '#fff', fontWeight: '700' },
  taskBody: { flex: 1 },
  taskTitle: { fontSize: 16, fontWeight: '500' },
  taskTitleDone: { textDecorationLine: 'line-through', color: '#999' },
  taskNotes: { fontSize: 12, color: '#888', marginTop: 2 },
  priorityBadge: { width: 8, height: 8, borderRadius: 4, marginLeft: 8 },
});
