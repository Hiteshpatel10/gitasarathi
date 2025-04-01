# Keep Flutter's core classes from being obfuscated
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.app.** { *; }


-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**
# Firebase-related packages
-keep class com.google.firebase.** { *; }
-keep class io.flutter.plugins.firebase.** { *; }
-keep class com.google.firebase.messaging.** { *; }

# Google Sign-In
-keep class com.google.android.gms.auth.api.signin.** { *; }
-keep class com.google.android.gms.auth.api.signin.internal.** { *; }

# Flutter Local Notifications
-keep class io.flutter.plugins.flutterlocalnotifications.** { *; }

# Dio (HTTP client)
-keep class io.dio.** { *; }

# Cached Network Image
-keep class com.github.bumptech.glide.** { *; }

# SharedPreferences
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# Logger
-keep class com.orhanobut.logger.** { *; }

# WorkManager (Background tasks)
-keep class androidx.work.** { *; }

# Uni Links (deep linking)
-keep class me.everything.** { *; }

# Other necessary keep rules based on your plugins
-keep class com.github.ybq.** { *; } # For lottie (if you use lottie animations)
-keep class com.shrikanth.** { *; } # For RateMyApp package
