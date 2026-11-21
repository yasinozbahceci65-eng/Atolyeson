import { ActivityIndicator, StyleSheet, Text, View } from 'react-native';
import { useEffect } from 'react';
import { useRouter } from 'expo-router';
import { Colors } from '@/lib/colors';

export default function AuthCallbackScreen() {
  const router = useRouter();

  useEffect(() => {
    const timeout = setTimeout(() => router.replace('/login'), 8000);
    return () => clearTimeout(timeout);
  }, [router]);

  return (
    <View style={styles.container}>
      <ActivityIndicator size="large" color={Colors.primary} />
      <Text style={styles.text}>Giriş tamamlanıyor...</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, alignItems: 'center', justifyContent: 'center', backgroundColor: Colors.neutral50, gap: 16 },
  text: { fontFamily: 'Inter-Medium', fontSize: 15, color: Colors.neutral600 },
});
