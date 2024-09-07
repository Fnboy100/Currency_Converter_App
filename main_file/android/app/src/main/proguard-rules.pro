# Keep the class handling API calls
-keep class com.example.myapp.network.get_exchangerate { *; }

# If you have a specific model class used for API responses, keep it as well
-keep class com.example.myapp.models.MyModelClass { *; }

# Keep all annotations to ensure they are not stripped away
-keepattributes *Annotation*

# Keep Flutter Secure Storage library
-keep class io.flutter.plugins.fluttersecurestorage.** { *; }

# Ensure Flutter Secure Storage is not obfuscated
-keep class com.it_nomads.fluttersecurestorage.** { *; }

# Preserve classes used in Flutter Secure Storage
-keep class android.security.keystore.** { *; }
-keep class javax.crypto.** { *; }

# Keep any classes that implement Serializable (optional, if needed)
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object readResolve();
    java.lang.Object writeReplace();