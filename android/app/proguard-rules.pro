# Keep the SplitCompatApplication class
-keep class com.google.android.play.core.splitcompat.SplitCompatApplication { *; }

# Keep TensorFlow Lite GPU Delegate classes
-keep class org.tensorflow.lite.gpu.GpuDelegateFactory$Options { *; }
-keep class org.tensorflow.lite.gpu.GpuDelegateFactory$Options$GpuBackend { *; }
-keep class org.tensorflow.lite.gpu.GpuDelegate { *; }
-keep class org.tensorflow.lite.gpu.GpuDelegate$Options { *; }

# JNI methods
-keepclasseswithmembers class * {
    native <methods>;
}

# Flutter-specific rules (important for Flutter apps)
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.**
