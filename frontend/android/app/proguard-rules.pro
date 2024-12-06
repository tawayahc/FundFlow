# Keep Google ErrorProne annotations
-keep class com.google.errorprone.annotations.** { *; }
-dontwarn com.google.errorprone.annotations.**

# Keep javax annotations
-keep class javax.annotation.** { *; }
-dontwarn javax.annotation.**

# Keep javax.concurrent annotations
-keep class javax.annotation.concurrent.** { *; }
-dontwarn javax.annotation.concurrent.**
