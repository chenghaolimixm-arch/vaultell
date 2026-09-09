# Flutter automatically adds this file to the release/R8 config (it is picked up
# from android/app/proguard-rules.pro). See FlutterPlugin.kt.

# google_mlkit_text_recognition references the Chinese/Japanese/Korean/Devanagari
# recognizer option classes via compileOnly (present at compile time, but not
# packaged at runtime). We only ever use the Latin script recognizer, so these
# classes are intentionally absent. Tell R8 not to treat them as missing classes.
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**

# If any of these classes are present in a future ML Kit version, keep them so
# reflection-based initialization continues to work.
-keep class com.google.mlkit.vision.text.chinese.** { *; }
-keep class com.google.mlkit.vision.text.devanagari.** { *; }
-keep class com.google.mlkit.vision.text.japanese.** { *; }
-keep class com.google.mlkit.vision.text.korean.** { *; }
