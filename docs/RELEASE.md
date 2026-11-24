# Release checklist

1. Review source, license and repository metadata.
2. Confirm both CI jobs passed; inspect all informational findings. Run the example and capture screenshots from an actual session.
3. Run `flutter pub publish --dry-run`. Confirm the package name is available and sign in to pub.dev with an account you control. Only then run `flutter pub publish` if you wish to publish; do not put credentials in Git.
4. On GitHub, create a release for tag `v0.2.0` on the tested commit. Use the changelog and accurately disclose known limitations. Do not claim unverified adoption.
5. Share the library with developers who actually need it; collect issue reports, and maintain it.
