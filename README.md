# docker-electron-installer-windows

Docker image to build Electron Windows Installer using:
    - [electron-packager](https://github.com/electron-userland/electron-packager)
    - [electron-installer-windows](https://github.com/unindented/electron-installer-windows)

## Why?

I've tried to build my Electon Windows Installers using continuous integration, and especially CircleCi.

### Issues with electronuserland/builder:wine-mono

Using docker image [electronuserland/builder:wine-mono](https://hub.docker.com/r/electronuserland/) is not working. 

While using [electron-packager](https://github.com/electron-userland/electron-packager) I've encouner the following error.


The issue is that mono version is v4.x.x but Nuget works on v5.x.x [see](https://github.com/NuGet/Home/issues/6790)

### Extending [electronuserland/builder:wine](https://hub.docker.com/r/electronuserland/) with mono v5.x.x

After [installing mono v5.x.x](https://www.mono-project.com/download/stable/#download-lin), I've ended up with the following error:


```
Error: Error releasifying package: Error executing command (Exited with status 255):
mono /home/circleci/repo/node_modules/electron-installer-windows/vendor/squirrel/Squirrel-Mono.exe --releasify /tmp/electron-95kke2D17wvHEs/create-react-app-example_0.1.0-rc7/nuget/create-react-app-example.0.1.0-rc7.nupkg --releaseDir /tmp/electron-95kke2D17wvHEs/create-react-app-example_0.1.0-rc7/squirrel --setupIcon /home/circleci/repo/adloader-project/assets/package.ico --loadingGif /home/circleci/repo/adloader-project/assets/loader.gif --no-msi
System.AggregateException: One or more errors occurred. ---> System.Exception: wine: cannot find L"C:\\windows\\system32\\winemenubuilder.exe"
000b:err:wineboot:ProcessRunKeys Error running cmd L"C:\\windows\\system32\\winemenubuilder.exe -a -r" (2)
0009:err:process:create_process 64-bit application L"Z:\\home\\circleci\\repo\\node_modules\\electron-installer-windows\\vendor\\squirrel\\7z.exe" not supported in 32-bit prefix
wine: Bad EXE format for Z:\home\circleci\repo\node_modules\electron-installer-windows\vendor\squirrel\7z.exe.
  at Squirrel.Utility+<CreateZipFromDirectory>d__23.MoveNext () [0x000ff] in <529cc2cd4af044829f92664c5d854efd>:0 
   --- End of inner exception stack trace ---
  at System.Threading.Tasks.Task.ThrowIfExceptional (System.Boolean includeTaskCanceledExceptions) [0x00011] in <2943701620b54f86b436d3ffad010412>:0 
  at System.Threading.Tasks.Task.Wait (System.Int32 millisecondsTimeout, System.Threading.CancellationToken cancellationToken) [0x00043] in <2943701620b54f86b436d3ffad010412>:0 
  at System.Threading.Tasks.Task.Wait () [0x00000] in <2943701620b54f86b436d3ffad010412>:0 
  at Squirrel.ReleasePackage.CreateReleasePackage (System.String outputFile, System.String packagesRootDir, System.Func`2[T,TResult] releaseNotesProcessor, System.Action`1[T] contentsPostProcessHook) [0x001f7] in <529cc2cd4af044829f92664c5d854efd>:0 
  at Squirrel.Update.Program.Releasify (System.String package, System.String targetDir, System.String packagesDir, System.String bootstrapperExe, System.String backgroundGif, System.String signingOpts, System.String baseUrl, System.String setupIcon, System.Boolean generateMsi, System.String frameworkVersion, System.Boolean generateDeltas) [0x00214] in <529cc2cd4af044829f92664c5d854efd>:0 
  at Squirrel.Update.Program.executeCommandLine (System.String[] args) [0x004a2] in <529cc2cd4af044829f92664c5d854efd>:0 
  at Squirrel.Update.Program.main (System.String[] args) [0x00082] in <529cc2cd4af044829f92664c5d854efd>:0 
  at Squirrel.Update.Program.Main (System.String[] args) [0x00006] in <529cc2cd4af044829f92664c5d854efd>:0 
---> (Inner Exception #0) System.Exception: wine: cannot find L"C:\\windows\\system32\\winemenubuilder.exe"
000b:err:wineboot:ProcessRunKeys Error running cmd L"C:\\windows\\system32\\winemenubuilder.exe -a -r" (2)
0009:err:process:create_process 64-bit application L"Z:\\home\\circleci\\repo\\node_modules\\electron-installer-windows\\vendor\\squirrel\\7z.exe" not supported in 32-bit prefix
wine: Bad EXE format for Z:\home\circleci\repo\node_modules\electron-installer-windows\vendor\squirrel\7z.exe.
  at Squirrel.Utility+<CreateZipFromDirectory>d__23.MoveNext () [0x000ff] in <529cc2cd4af044829f92664c5d854efd>:0 <---
```

This is due to 7zip shipped in electron-installer-windows is in 64bits. You can replace it with the 32bits version, to 
make it working like explained [here](https://github.com/electron/windows-installer/issues/186#issuecomment-313222658) 
but I'm not fan of that solution.

> After trying thoses solutions, I've decided to create my own docker image

## What's inside?
    
- Extending [circleci/node:9](https://hub.docker.com/r/circleci/node/tags/)
- Install [winehq-stable](https://wiki.winehq.org/Ubuntu)
- Install [mono-devel](https://www.mono-project.com/download/stable/#download-lin)
